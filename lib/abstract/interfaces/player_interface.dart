import 'package:spotify/spotify.dart';

abstract interface class PlayerInterface {
  Future<void> play(String trackId);
  Future<void> pause();
  Future<void> nextTrack();
  Future<void> prevTrack();
  Future<Track?> getCurrentTrack();
  Future<PlaybackState> getPlaybackState();
}
