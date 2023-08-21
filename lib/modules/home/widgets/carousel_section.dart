import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_tab_controller.dart';

import 'big_track_card.dart';

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = Get.find<HomeTabController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Obx(
            () => Text(
              tabController.currentTab.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Obx(
            () {
              final tracks = tabController.currentTab.tracks;
              return tracks.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 15),
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks.elementAt(index);
                        return BigTrackCard(track: track);
                      },
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
