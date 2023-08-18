import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/abstract/services/auth_service.dart';
import 'package:spotify_remake_getx/implementation/services/auth_service.dart';
import 'package:spotify_remake_getx/implementation/services/credentials_repository.dart';
import 'package:spotify_remake_getx/routes.dart';

import 'app.dart';
import 'modules/home/bindings.dart';
import 'modules/home/home_page.dart';

class AuthBinding extends Bindings {
  final AuthService authService;
  AuthBinding({required this.authService});

  @override
  void dependencies() {
    Get.putAsync<ApiService>(() async {
      final apiService = await authService.authorize();
      return apiService;
    });
  }
}

void main() {
  runApp(
    GetMaterialApp(
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
          binding: HomeBinding(),
        ),
      ],
    ),
  );
}
