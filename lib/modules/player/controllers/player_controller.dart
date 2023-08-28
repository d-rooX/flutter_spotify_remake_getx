import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';

class PlayerController extends GetxController {
  final PlayerInterface api;
  PlayerController({required this.api});

  Rx<Track?> currentTrack = Rx(null);

  @override
  void onInit() {
    getCurrentTrack();
    super.onInit();
  }

  Future<void> getCurrentTrack() async {
    final _currentTrack = await api.getCurrentTrack();
    if (_currentTrack != null) {
      currentTrack.value = _currentTrack;
      return;
    }
    // final pbState = await api.getPlaybackState();
  }

  Future<void> play(String trackId) async {
    final playbackState = await api.play(trackId);
  }

  Future<void> getPlaybackState() {
    // TODO: implement getPlaybackState
    throw UnimplementedError();
  }
}
