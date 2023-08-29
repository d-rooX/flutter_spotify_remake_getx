import 'package:get/get.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_controller.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    final apiService = Get.find<ApiService>();
    apiService.connectToSpotifySDK();
    Get.put(HomeController(api: apiService));
    Get.put(PlayerController(api: apiService));
  }
}
