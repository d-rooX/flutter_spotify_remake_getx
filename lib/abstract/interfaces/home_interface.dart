import 'package:spotify/spotify.dart';

abstract interface class HomeInterface {
  Future<Iterable<PlayHistory>> loadRecentlyPlayed();
  Future<Recommendations> loadRecommendedTracks();
  Future<Iterable<Track>> loadTrendingTracks();
  Future<Track> loadTrack(String id);
  Future<Playlist> loadPlaylist(String id);
}
