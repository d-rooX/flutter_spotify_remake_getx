import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_controller.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_tab_controller.dart';
import 'package:spotify_remake_getx/modules/home/widgets/carousel_section.dart';
import 'package:spotify_remake_getx/modules/home/widgets/home_search_bar.dart';
import 'package:spotify_remake_getx/modules/home/widgets/home_tabs.dart';
import 'package:spotify_remake_getx/modules/home/widgets/track_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;
  late HomeTabController tabController;

  @override
  void initState() {
    controller = Get.find<HomeController>();
    tabController = Get.put(
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
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
              Obx(() => TrackList(tracks: tabController.currentTab.tracks)),
            ],
          ),
        ),
      ),
    );
  }
}
