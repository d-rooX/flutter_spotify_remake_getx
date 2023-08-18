import 'dart:developer';

import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/home_interface.dart';

class HomeController extends GetxController {
  final HomeInterface api;
  HomeController({required this.api});

  var recentlyPlayed = <PlayHistory>[].obs;
  var recommendedTracks = <Track>[].obs;
  var trendingTracks = <Track>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentlyPlayed();
    loadRecommendedTracks();
    loadTrendingTracks();
  }

  Future<void> loadRecentlyPlayed() async {
    log("loading recently played");
    final result = await api.loadRecentlyPlayed();
    recentlyPlayed.assignAll(result);
  }

  Future<void> loadRecommendedTracks() async {
    log("loading recommended tracks");
    final result = await api.loadRecommendedTracks();
    final tracks = <Track>[];
    for (final track in result.tracks!) {
      final fullTrack = await api.loadTrack(track.id!);
      tracks.add(fullTrack);
    }

    recommendedTracks.assignAll(tracks);
  }

  Future<void> loadTrendingTracks() async {
    // Load trending tracks from API
  }
}
