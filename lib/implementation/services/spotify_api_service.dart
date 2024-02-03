import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/implementation/interfaces/spotify_home.dart';
import 'package:spotify_remake_getx/implementation/interfaces/spotify_player.dart';

class SpotifyApiService extends ApiService with SpotifyHome, SpotifyPlayer {
  SpotifyApiService(super.api);
}
