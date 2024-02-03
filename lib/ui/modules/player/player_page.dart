import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/ui/modules/player/controllers/player_controller.dart';
import 'package:spotify_remake_getx/ui/modules/player/widgets/player_bottom.dart';
import 'package:spotify_remake_getx/ui/modules/player/widgets/player_top.dart';
import 'package:spotify_remake_getx/ui/modules/player/widgets/track_cover.dart';

class PlayerPage extends GetView<PlayerController> {
  final CachedNetworkImageProvider? openedTrackImageProvider;
  const PlayerPage({
    super.key,
    this.openedTrackImageProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (openedTrackImageProvider != null) {
      controller.imageProvider.value = openedTrackImageProvider;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.playbackState.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return const _LoadedPlayerPage();
      }),
    );
  }
}

class _LoadedPlayerPage extends GetView<PlayerController> {
  const _LoadedPlayerPage();

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
                const SizedBox(height: 30),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 350,
                  height: 350,
                  padding: EdgeInsets.all(controller.isPlaying.value ? 0 : 5),
                  child: TrackCover(
                    imageProvider: controller.imageProvider.value!,
                    trackId: controller.currentTrack.value!.id!,
                  ),
                ),
                const SizedBox(height: 15),
                const PlayerBottom(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
