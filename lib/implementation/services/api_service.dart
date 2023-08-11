import 'dart:math' show Random;

import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/domain/services/api_service.dart';

class SpotifyApiService implements ApiServiceInterface {
  final SpotifyApi api;
  const SpotifyApiService(this.api);

  @override
  Future<Iterable<PlayHistory>> loadRecentlyPlayed() async {
    final result = await api.me.recentlyPlayed().all();
    return result;
  }

  @override
  Future<Recommendations> loadRecommendedTracks() async {
    final fav = await api.tracks.me.saved.getPage(10, Random().nextInt(15));
    final List<String> seedTracks = [];
    for (int i = 0; i < 3; i++) {
      seedTracks.add(
        fav.items!.elementAt(Random().nextInt(fav.items!.length)).track!.id!,
      );
    }

    final recommendations = await api.recommendations.get(
      seedTracks: seedTracks,
      seedArtists: (await api.me.topArtists()).map((e) => e.id!).take(2),
      seedGenres: [],
      limit: 20,
    );
    return recommendations;
  }

  @override
  Future<Iterable<Track>> loadTrendingTracks() {
    throw UnimplementedError();
  }

  @override
  Future<Track> loadTrack(String id) async {
    final track = await api.tracks.get(id);
    return track;
  }

  @override
  Future<Playlist> loadPlaylist(String id) async {
    final playlist = await api.playlists.get(id);
    return playlist;
  }
}
