import 'dart:developer';
import 'dart:math' show Random;

import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/app.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

// Future<void> saveResultToJson(String key, Map<String, dynamic> data) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final filePath = '${directory.path}/mockDB.json';
//   final file = File.fromUri(Uri.file(filePath));
//
//   if (!await file.exists()) {
//     await file.create();
//   }
//
//   log(filePath, name: "MockJsonFilePath");
//
//   final data = json.decode(await file.readAsString());
//   log(data);
// }

class SpotifyApiService implements ApiService {
  final SpotifyApi api;
  const SpotifyApiService(this.api);

  @override
  Future<void> connectToSpotifySDK() async {
    final credentials = await api.getCredentials();
    final result = await SpotifySdk.connectToSpotifyRemote(
      clientId: credentials.clientId!,
      redirectUrl: AppConstants.REDIRECT_URL,
      accessToken: credentials.accessToken,
      playerName: "droox Flutter Remake",
    );
    log("Done connection with result: $result", name: "SpotifySDKConnection");
  }

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

  // Future<Stream<Track>> loadTracks(Iterable<String> trackIds ids) {
  //  todo make batch track fetch
  // }

  @override
  Future<Playlist> loadPlaylist(String id) async {
    final playlist = await api.playlists.get(id);
    return playlist;
  }

  @override
  Future<PlaybackState?> play(String trackId) async {
    await api.player.addToQueue(trackId);
    return await api.player.next();
  }

  @override
  Future<PlaybackState> getPlaybackState() async {
    try {
      final state = await api.player.playbackState();
      return state;
    } catch (e) {
      final devices = await api.player.devices();
      for (final device in devices) {
        log("Device: ${device.name!}; Id: ${device.id!}");
      }

      rethrow;
    }
  }

  @override
  Future<Track?> getCurrentTrack() async {
    final data = await api.player.currentlyPlaying();
    return data.item;
  }
}
