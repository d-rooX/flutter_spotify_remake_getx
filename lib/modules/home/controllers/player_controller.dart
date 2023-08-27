import 'package:get/get.dart';
import 'package:spotify_remake_getx/abstract/interfaces/player_interface.dart';

class PlayerController extends GetxController {
  final PlayerInterface api;
  PlayerController({required this.api});

  Future<void> play(String trackId) async {
    await api.play(trackId);
  }
}
