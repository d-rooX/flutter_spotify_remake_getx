import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

mixin SpotifyPlayer on ApiService implements PlayerInterface {
  @override
  Future<void> play(String trackId) async {
    SpotifySdk.play(spotifyUri: trackId);
  }

  @override
  Future<Track?> getCurrentTrack() async {
    final data = await api.player.currentlyPlaying();
    return data.item;
  }
}
