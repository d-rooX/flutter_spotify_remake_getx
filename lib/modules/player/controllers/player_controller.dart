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

  Rx<Track?> currentTrack = Rx(null);
  var paletteColors = <Color>[].obs;

  @override
  void onInit() {
    _initSpotifySDK();
    super.onInit();
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

  Future<void> _initSpotifySDK() async {
    await SpotifySdk.connectToSpotifyRemote(
      clientId: AppConstants.CLIENT_ID,
      redirectUrl: AppConstants.REDIRECT_URL,
      accessToken: await _getAccessToken(),
    );
    SpotifySdk.subscribePlayerState().listen(
      (event) async {
        print(event.playbackPosition);

        await Future.delayed(
          const Duration(milliseconds: 500),
          () async {
            final _currentTrack = await api.getCurrentTrack();
            if (_currentTrack != null) currentTrack.value = _currentTrack;
          },
        );
      },
    );
  }
}
