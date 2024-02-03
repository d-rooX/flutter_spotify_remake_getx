import 'package:spotify_remake_getx/abstract/interfaces/spotify_api_service_interface.dart';
import 'package:spotify_remake_getx/implementation/interfaces/spotify_home.dart';
import 'package:spotify_remake_getx/implementation/interfaces/spotify_player.dart';

class SpotifyApiService extends SpotifyApiServiceInterface
    with SpotifyHome, SpotifyPlayer {
  SpotifyApiService(super.api);
}
