import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.home),
              child: const Text("Home"),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.player),
              child: const Text("Player"),
            ),
          ],
        ),
      ),
    );
  }
}
