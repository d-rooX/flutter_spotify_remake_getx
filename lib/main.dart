import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify_remake_getx/app.dart';
import 'package:spotify_remake_getx/bindings/auth_binding.dart';
import 'package:spotify_remake_getx/implementation/services/spotify_auth_service.dart';
import 'package:spotify_remake_getx/implementation/services/spotify_credentials_repository.dart';
import 'package:spotify_remake_getx/routes.dart';
import 'package:spotify_remake_getx/ui/modules/home/home_page.dart';
import 'package:spotify_remake_getx/ui/modules/player/player_page.dart';

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
          name: Routes.home,
          page: () => const HomePage(),
        ),
        GetPage(
          name: Routes.player,
          page: () => const PlayerPage(),
        ),
      ],
    ),
  );
}
