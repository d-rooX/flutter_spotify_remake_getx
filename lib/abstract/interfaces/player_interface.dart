import 'package:spotify/spotify.dart';

abstract interface class PlayerInterface {
  Future<void> play(String trackId);
  Future<Track?> getCurrentTrack();
}
