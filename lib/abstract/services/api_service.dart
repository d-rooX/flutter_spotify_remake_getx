import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/home_interface.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';

abstract class ApiService implements HomeInterface, PlayerInterface {
  final SpotifyApi api;
  const ApiService(this.api);
}
