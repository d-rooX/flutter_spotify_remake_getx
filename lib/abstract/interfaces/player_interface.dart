import 'package:spotify/spotify.dart';

abstract interface class PlayerInterface {
  Future<void> play(String trackId);
  Future<void> pause();
  Future<Track?> getCurrentTrack();
  Future<PlaybackState> getPlaybackState();
}
