import 'dart:math';

import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/home_interface.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';

mixin SpotifyHome on ApiService implements HomeInterface {
  @override
  Future<Iterable<PlayHistory>> loadRecentlyPlayed() async {
    final result = await api.me.recentlyPlayed().all();
    return result;
  }

  @override
  Future<Recommendations> loadRecommendedTracks() async {
    final random = Random();
    final fav = await api.tracks.me.saved.getPage(10, random.nextInt(15));

    final List<String> seedTracks = [];
    for (int i = 0; i < 3; i++) {
      seedTracks.add(
        fav.items!.elementAt(random.nextInt(fav.items!.length)).track!.id!,
      );
    }

    final recommendations = await api.recommendations.get(
      seedTracks: seedTracks,
      seedArtists: await _getSeedArtists(),
      seedGenres: [],
      limit: 20,
    );
    return recommendations;
  }

  /// Returns itearble of top artists ids
  Future<Iterable<String>> _getSeedArtists() async {
    final topArtists = (await api.me.topArtists().first(10)).items;
    if (topArtists == null) {
      throw "Top artists are null";
    }

    return topArtists.map((e) => e.id!).take(2);
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
