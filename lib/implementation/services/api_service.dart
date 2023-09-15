import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/implementation/interfaces/home_interface.dart';
import 'package:spotify_remake_getx/implementation/interfaces/player_interface.dart';

class SpotifyApiService extends ApiService with SpotifyHome, SpotifyPlayer {
  SpotifyApiService(super.api);
}
