import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';
import 'package:spotify_remake_getx/app_constants.dart';
import 'package:spotify_remake_getx/ui/common/extensions/track_extension.dart';
import 'package:spotify_remake_getx/utils.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlayerController extends GetxController {
  final PlayerInterface api;
  final currentTrack = Rx<Track?>(null);
  final trackDuration = Rx<Duration?>(null);
  final progressMs = RxInt(0);
  final isPlaying = RxBool(false);

  final playbackState = Rx<PlaybackState?>(null);
  final paletteColors = <Color>[].obs;
  final imageProvider = Rx<CachedNetworkImageProvider?>(null);

  static const _lightColorLuminanceThreshold = 0.6;
  static const _lightColorOpacity = 0.7;

  Timer? timer;

  PlayerController({required this.api});
  @override
  Future<void> onInit() async {
    final successfullyLoaded = await _initSpotifySDK();
    if (successfullyLoaded) {
      await _getPlaybackState();
      await _loadImage();
    } else {
      unawaited(_showLoadingErrorDialog());
    }
    super.onInit();
  }

  Future<void> togglePlay() async {
    if (isPlaying.value) {
      unawaited(api.pause());
    } else {
      unawaited(SpotifySdk.resume());
    }
    isPlaying.toggle();
  }

  Future<void> play(Track track) async {
    currentTrack.value = track;
    isPlaying.value = false;

    final uri = track.uri;
    if (uri == null) throw "Track uri is not received";

    await api.play(uri);
  }

  Future<void> nextTrack() async {
    isPlaying.value = false;
    await api.nextTrack();
  }

  Future<void> prevTrack() async {
    isPlaying.value = false;
    await api.prevTrack();
  }

  Future<void> _loadImage() async {
    final _imageProvider =
        CachedNetworkImageProvider(currentTrack.value!.bigImageUrl);
    imageProvider.value = _imageProvider;

    final _paletteColors = <Color>[];
    for (final color in await Utils.getImagePalette(_imageProvider)) {
      Color _color = color.color;
      if (_color.computeLuminance() > _lightColorLuminanceThreshold) {
        _color = _color.withOpacity(_lightColorOpacity);
      }
      _paletteColors.add(_color);
    }

    paletteColors.assignAll(_paletteColors);
  }

  Future _getPlaybackState() async {
    playbackState.value = await api.getPlaybackState();
    currentTrack.value = playbackState.value!.item;
    isPlaying.value = playbackState.value!.isPlaying!;
  }

  // todo move private methods to class
  // todo fix dependency problem
  Future<String> _getAccessToken() async {
    final storage = await SharedPreferences.getInstance();
    String? accessToken = storage.getString("spotifySDK_AccessToken");
    accessToken ??= await SpotifySdk.getAccessToken(
      clientId: AppConstants.clientID,
      redirectUrl: AppConstants.redirectURL,
    );

    await storage.setString('spotifySDK_AccessToken', accessToken);
    return accessToken;
  }

  void _subscribeToPlayerState() {
    SpotifySdk.subscribePlayerState().listen(
      (event) async {
        print(event.track);

        await Future.delayed(
          const Duration(milliseconds: 50),
          _onNewTrack,
        );
      },
    );
  }

  Future<void> _onNewTrack() async {
    try {
      await _getPlaybackState();
    } catch (e) {
      log(
        "Error while loading playback state",
        error: "No playback state was got from spotify",
      );
    }

    await _getTrackDuration();
    await _loadImage();
    _startTimer();
  }

  Future<bool> _initSpotifySDK() async {
    try {
      await SpotifySdk.connectToSpotifyRemote(
        clientId: AppConstants.clientID,
        redirectUrl: AppConstants.redirectURL,
        accessToken: await _getAccessToken(),
      );
      _subscribeToPlayerState();

      return true;
    } on PlatformException catch (e) {
      if (e.code == 'CouldNotFindSpotifyApp') {
        print('NOT FOUND SPOTIFY APP');
      }
    }

    return false;
  }

  Future<void> _getTrackDuration() async {
    final state = playbackState.value;
    if (state == null) {
      return;
    }

    progressMs.value = state.progress_ms!;
    isPlaying.value = state.isPlaying!;
    trackDuration.value = state.item?.duration;
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!isPlaying.value) {
        timer.cancel();
        return;
      }

      if (trackDuration.value != null) {
        if (progressMs.value < trackDuration.value!.inMilliseconds) {
          progressMs.value += 300;
        } else {
          timer.cancel();
          isPlaying.value = false;
        }
      }
    });
  }

  Future<void> _showLoadingErrorDialog() {
    return Get.dialog(
      const AlertDialog(
        backgroundColor: Colors.black,
        content: SizedBox(
          height: 100,
          width: 150,
          child: Center(
            child: Text(
              "Looks like there was an error while loading an app.\n"
              "Player wouldn't be available",
              style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
            ),
          ),
        ),
      ),
    );
  }
}
