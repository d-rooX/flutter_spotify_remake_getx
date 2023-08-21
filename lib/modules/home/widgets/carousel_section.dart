import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers.dart';

import 'big_track_card.dart';

class CarouselSection extends GetView<HomeController> {
  final String title;
  const CarouselSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Obx(
            () => controller.recommendedTracks.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemCount: controller.recommendedTracks.length,
                    itemBuilder: (context, index) {
                      final track = controller.recommendedTracks[index];
                      return BigTrackCard(track: track);
                    },
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
