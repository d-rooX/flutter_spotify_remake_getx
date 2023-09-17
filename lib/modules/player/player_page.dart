import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';
import 'package:spotify_remake_getx/modules/player/widgets/player_bottom.dart';
import 'package:spotify_remake_getx/modules/player/widgets/player_top.dart';
import 'package:spotify_remake_getx/modules/player/widgets/track_cover.dart';

class PlayerPage extends GetView<PlayerController> {
  final ImageProvider? openedTrackImageProvider;
  const PlayerPage({
    super.key,
    this.openedTrackImageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.playbackState.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _LoadedPlayerPage(openedTrackImageProvider);
      }),
    );
  }
}

class _LoadedPlayerPage extends GetView<PlayerController> {
  final ImageProvider? openedTrackImageProvider;
  const _LoadedPlayerPage(this.openedTrackImageProvider);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            gradient: controller.paletteColors.isNotEmpty
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: controller.paletteColors.take(2).toList(),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(height: Get.mediaQuery.padding.top + 25),
                const PlayerTop(),
                const SizedBox(height: 50),
                TrackCover(
                  imageProvider: openedTrackImageProvider ??
                      controller.imageProvider.value ??
                      Image.network("https://shorturl.at/iyQT3").image,
                  trackId: controller.currentTrack.value!.id!,
                ),
                const SizedBox(height: 40),
                const PlayerBottom()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
