import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Text(controller.recommendedTracks.toString())),
      ),
    );
  }
}
