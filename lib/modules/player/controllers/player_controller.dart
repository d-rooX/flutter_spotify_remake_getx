import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' show Color;
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

  final progressMs = RxInt(0);
  final trackDuration = Rx<Duration?>(null);
  final isPlaying = RxBool(false);

  final playbackState = Rx<PlaybackState?>(null);
  final paletteColors = <Color>[].obs;
  final imageProvider = Rx<CachedNetworkImageProvider?>(null);
  Timer? timer;

  Track? get currentTrack => playbackState.value!.item;

  @override
  void onInit() {
    _initSpotifySDK();
    _getPlaybackState();
    super.onInit();
  }

  void refreshTrackDuration() async {
    await _getTrackDuration();
    _startTimer();
  }

  Future<void> play(String trackId) async {
    isPlaying.value = false;
    imageProvider.value = null;
    progressMs.value = 0;

    await api.play(trackId);
  }

  void _loadImage() async {
    final _imageProvider =
        CachedNetworkImageProvider(currentTrack!.album!.images![0].url!);
    imageProvider.value = _imageProvider;

    final _paletteColors = <Color>[];
    for (final color in await Utils.getImagePalette(_imageProvider)) {
      Color _color = color.color;
      if (_color.computeLuminance() > 0.5) {
        _color = _color.withOpacity(0.7);
      }
      _paletteColors.add(_color);
    }

    paletteColors.assignAll(_paletteColors);
  }

  Future _getPlaybackState() async {
    playbackState.value = await api.getPlaybackState();
    _loadImage();
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
    SpotifySdk.subscribePlayerState().listen((event) async {
      await Future.delayed(
        const Duration(milliseconds: 50),
        () async {
          try {
            playbackState.value = await api.getPlaybackState();
          } catch (e) {
            log("No playback state was got from spotify", error: true);
          }

          refreshTrackDuration();
          _loadImage();
        },
      );
    });
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
    trackDuration.value = state.item!.duration;
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
