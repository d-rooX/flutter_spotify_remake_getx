import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

mixin SpotifyPlayer on ApiService implements PlayerInterface {
  @override
  Future<void> play(String trackId) async {
    await SpotifySdk.play(spotifyUri: trackId);
  }

  @override
  Future<void> pause() async {
    await SpotifySdk.pause();
  }

  @override
  Future<void> nextTrack() async {
    await SpotifySdk.skipNext();
  }

  @override
  Future<void> prevTrack() async {
    await SpotifySdk.skipPrevious();
  }

  @override
  Future<Iterable<Track>> getQueue() async {
    final queue = await api.player.queue();
    for (final track in queue.queue!) {
      print(
        "${track.name!} --- ${track.artists!.map((e) => e.name).join(", ")}",
      );
    }

    return queue.queue!;
  }

  @override
  Future<Track?> getCurrentTrack() async {
    final data = await api.player.currentlyPlaying();
    return data.item;
  }

  @override
  Future<PlaybackState> getPlaybackState() async {
    final state = await api.player.playbackState();
    return state;
  }
}
