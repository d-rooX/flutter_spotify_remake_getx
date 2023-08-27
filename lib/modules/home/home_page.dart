import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_controller.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_tab_controller.dart';
import 'package:spotify_remake_getx/modules/home/widgets/carousel_section.dart';
import 'package:spotify_remake_getx/modules/home/widgets/home_search_bar.dart';
import 'package:spotify_remake_getx/modules/home/widgets/home_tabs.dart';
import 'package:spotify_remake_getx/widgets/track_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final tabController = Get.put(
      HomeTabController(tabs: [
        HomeTracksTab(
          title: "Recommended",
          tracks: controller.recommendedTracks,
        ),
        HomeTracksTab(
          title: "Recently Played",
          tracks: controller.recentlyPlayed,
        ),
      ]),
    );

    return Scaffold(
      extendBody: true,
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(52, 37, 71, 1),
                Color.fromRGBO(29, 30, 53, 1),
              ],
            ),
          ),
          child: RefreshIndicator(
            edgeOffset: Get.mediaQuery.padding.top,
            displacement: 80,
            onRefresh: () async => controller.reload(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.mediaQuery.padding.top),
                  const HomeSearchBar(),
                  const SizedBox(height: 10),
                  const CarouselSection(),
                  const SizedBox(height: 20),
                  const HomeTabs(),
                  const SizedBox(height: 20),
                  Obx(
                    () => tabController.currentTab.tracks.isNotEmpty
                        ? TrackList(tracks: tabController.currentTab.tracks)
                        : const Center(child: Text("Loading...")),
                  ),
                  SizedBox(height: Get.mediaQuery.padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
