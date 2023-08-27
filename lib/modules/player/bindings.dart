import 'package:get/get.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    final api = Get.find<ApiService>();
    Get.put(PlayerController(api: api));
  }
}
