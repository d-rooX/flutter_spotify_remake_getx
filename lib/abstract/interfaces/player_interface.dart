import 'package:spotify/spotify.dart';

abstract interface class PlayerInterface {
  Future<void> play(String trackId);
  Future<PlaybackState> getPlaybackState();
  Future<Track?> getCurrentTrack();
}
