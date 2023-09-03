import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/abstract/services/auth_service.dart';
import 'package:spotify_remake_getx/implementation/services/spotify/api_service.dart';
import 'package:spotify_remake_getx/implementation/services/spotify/auth_service.dart';
import 'package:spotify_remake_getx/implementation/services/spotify/credentials_repository.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_controller.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';
import 'package:spotify_remake_getx/modules/player/player_page.dart';
import 'package:spotify_remake_getx/routes.dart';

import 'app.dart';
import 'modules/home/home_page.dart';

class AuthBinding extends Bindings {
  final AuthService<SpotifyApiService> authService;
  AuthBinding({required this.authService});

  @override
  void dependencies() {
    Get.putAsync<ApiService>(
      () => authService.authorize(),
    ).then(
      // fixme move to another class
      (value) {
        Get.put(PlayerController(api: value));
        Get.put(HomeController(api: value));
      },
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Typography.whiteCupertino),
      ),
      debugShowCheckedModeBanner: false,
      home: const App(),
      initialBinding: AuthBinding(
        authService: SpotifyAuthService(
          credentialsRepository: SpotifyCredentialsRepository(),
        ),
      ),
      getPages: [
        GetPage(
          name: Routes.HOME,
          page: () => const HomePage(),
        ),
        GetPage(
          name: Routes.PLAYER,
          page: () => const PlayerPage(),
        ),
      ],
    ),
  );
}
