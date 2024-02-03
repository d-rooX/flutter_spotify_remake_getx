import 'package:get/get.dart';
import 'package:spotify_remake_getx/abstract/services/auth_service.dart';
import 'package:spotify_remake_getx/implementation/services/spotify_api_service.dart';
import 'package:spotify_remake_getx/ui/modules/home/controllers/home_controller.dart';
import 'package:spotify_remake_getx/ui/modules/player/controllers/player_controller.dart';

class AuthBinding extends Bindings {
  final AuthService<SpotifyApiService> authService;

  AuthBinding({required this.authService});

  @override
  void dependencies() {
    Get.putAsync<SpotifyApiService>(authService.authorize).then(
      // fixme move to another class
      (value) {
        Get.put(PlayerController(api: value));
        Get.put(HomeController(api: value));
      },
    );
  }
}
