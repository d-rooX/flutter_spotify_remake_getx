import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers.dart';
import 'package:spotify_remake_getx/modules/home/widgets/carousel_section.dart';
import 'package:spotify_remake_getx/modules/home/widgets/home_search_bar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple,
              Colors.black.withBlue(25).withRed(10),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.mediaQuery.padding.top),
            const HomeSearchBar(),
            const SizedBox(height: 15),
            const CarouselSection(title: "Trending right now")
          ],
        ),
      ),
    );
  }
}
