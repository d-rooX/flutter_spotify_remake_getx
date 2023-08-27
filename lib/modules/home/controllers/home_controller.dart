import 'dart:developer';

import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/home_interface.dart';

class HomeController extends GetxController {
  final HomeInterface api;
  HomeController({required this.api});

  var recentlyPlayed = <Track>[].obs;
  var recommendedTracks = <Track>[].obs;
  var trendingTracks = <Track>[].obs;

  @override
  void onInit() {
    reload();
    super.onInit();
  }

  void reload() {
    recentlyPlayed.clear();
    recommendedTracks.clear();
    trendingTracks.clear();

    loadRecentlyPlayed();
    loadRecommendedTracks();
    loadTrendingTracks();
  }

  Future<void> loadRecentlyPlayed() async {
    log("loading recently played");

    final List<TrackSimple> tracks = [];
    for (final entry in await api.loadRecentlyPlayed()) {
      final track = entry.track!;
      if (!tracks.contains(track)) {
        tracks.add(track);
      }
    }

    final res = await _loadFullTracks(tracks);
    recentlyPlayed.assignAll(res);
  }

  Future<void> loadRecommendedTracks() async {
    log("loading recommended tracks");
    final result = await api.loadRecommendedTracks();
    final tracks = await _loadFullTracks(result.tracks!);

    recommendedTracks.assignAll(tracks);
  }

  Future<void> loadTrendingTracks() async {
    // Load trending tracks from API
  }

  Future<List<Track>> _loadFullTracks(Iterable<TrackSimple> tracks) async {
    final result = <Track>[];
    for (final track in tracks) {
      final fullTrack = await api.loadTrack(track.id!);
      result.add(fullTrack);
    }
    return result;
  }
}
