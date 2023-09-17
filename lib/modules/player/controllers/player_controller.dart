import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart' show Color;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';
import 'package:spotify_remake_getx/app.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlayerController extends GetxController {
  final PlayerInterface api;
  PlayerController({required this.api});

  final progressMs = RxInt(0);
  final trackDuration = Rx<Duration?>(null);
  final isPlaying = RxBool(false);

  final playbackState = Rx<PlaybackState?>(null);
  final paletteColors = <Color>[].obs;
  Timer? timer;

  @override
  void onInit() {
    _initSpotifySDK();
    _getPlaybackState();
    super.onInit();
  }

  Future _getPlaybackState() async {
    playbackState.value = await api.getPlaybackState();
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

  _subscribeToPlayerState() {
    SpotifySdk.subscribePlayerState().listen((event) async {
      await Future.delayed(
        const Duration(milliseconds: 500),
        () async {
          try {
            playbackState.value = await api.getPlaybackState();
          } catch (e) {
            log("No playback state was got from spotify", error: true);
          }

          await refreshTrackDuration();
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

  refreshTrackDuration() async {
    await _getTrackDuration();
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPlaying.value) {
        timer.cancel();
        return;
      }

      if (trackDuration.value != null) {
        if (progressMs.value < trackDuration.value!.inMilliseconds) {
          progressMs.value += 1000;
        } else {
          timer.cancel();
          isPlaying.value = false;
        }
      }
    });
  }
}
