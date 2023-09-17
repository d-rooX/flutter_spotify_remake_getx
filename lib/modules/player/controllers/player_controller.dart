import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';
import 'package:spotify_remake_getx/app.dart';
import 'package:spotify_remake_getx/utils.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlayerController extends GetxController {
  final PlayerInterface api;
  PlayerController({required this.api});

  final currentTrack = Rx<Track?>(null);
  final trackDuration = Rx<Duration?>(null);
  final progressMs = RxInt(0);
  final isPlaying = RxBool(false);

  final playbackState = Rx<PlaybackState?>(null);
  final paletteColors = <Color>[].obs;
  final imageProvider = Rx<CachedNetworkImageProvider?>(null);

  Timer? timer;

  @override
  void onInit() {
    _initSpotifySDK();
    _getPlaybackState();
    _loadImage();
    super.onInit();
  }

  Future<void> togglePlay() async {
    if (isPlaying.value) {
      api.pause();
    } else {
      SpotifySdk.resume();
    }
    isPlaying.toggle();
  }

  Future<void> play(Track track) async {
    currentTrack.value = track;
    isPlaying.value = false;

    await api.play(track.uri!);
  }

  Future<void> nextTrack() async {
    isPlaying.value = false;
    await api.nextTrack();
  }

  Future<void> prevTrack() async {
    isPlaying.value = false;
    await api.prevTrack();
  }

  void _loadImage() async {
    final _imageProvider = CachedNetworkImageProvider(
      currentTrack.value!.album!.images![0].url!,
    );
    imageProvider.value = _imageProvider;

    final _paletteColors = <Color>[];
    for (final color in await Utils.getImagePalette(_imageProvider)) {
      Color _color = color.color;
      if (_color.computeLuminance() > 0.6) {
        _color = _color.withOpacity(0.7);
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
      clientId: AppConstants.CLIENT_ID,
      redirectUrl: AppConstants.REDIRECT_URL,
    );

    await storage.setString('spotifySDK_AccessToken', accessToken);
    return accessToken;
  }

  void _subscribeToPlayerState() {
    SpotifySdk.subscribePlayerState().listen(
      (event) async {
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
    _loadImage();
    _startTimer();
  }

  Future<void> _initSpotifySDK() async {
    await SpotifySdk.connectToSpotifyRemote(
      clientId: AppConstants.CLIENT_ID,
      redirectUrl: AppConstants.REDIRECT_URL,
      accessToken: await _getAccessToken(),
    );
    _subscribeToPlayerState();
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
}
