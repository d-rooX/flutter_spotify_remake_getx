import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';

class PlayerBottom extends GetView<PlayerController> {
  const PlayerBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final track = controller.currentTrack.value!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.name!,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  track.artists!.map((e) => e.name!).join(", "),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Obx(() {
            final currentMinutes =
                "${controller.progressMs.value ~/ 60000}:${((controller.progressMs.value ~/ 1000) % 60).toString().padLeft(2, '0')}";
            final duration = controller.trackDuration.value;
            String durationString = "HUI";
            if (duration != null) {
              durationString =
                  "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentMinutes),
                Text(durationString),
              ],
            );
          }),
          const SizedBox(height: 5),
          const PlaybackLine(),
          const SizedBox(height: 35),

          /// Control Panel
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PlaybackButton(
                  width: 12,
                  onTap: () async => await controller.prevTrack(),
                  icon: const Icon(Icons.chevron_left, size: 32),
                ),
                PlaybackButton(
                  width: 12,
                  onTap: () async => await controller.togglePlay(),
                  icon: controller.isPlaying.value
                      ? const Icon(Icons.pause, size: 32)
                      : const Icon(Icons.play_arrow, size: 32),
                ),
                PlaybackButton(
                  width: 12,
                  onTap: () async => await controller.nextTrack(),
                  icon: const Icon(Icons.chevron_right, size: 32),
                ),
              ],
            ),
          ),

          ///
        ],
      ),
    );
  }
}

class PlaybackButton extends StatelessWidget {
  final double width;
  final Icon icon;
  final VoidCallback? onTap;
  const PlaybackButton({
    super.key,
    required this.width,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(width),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}

class PlaybackLine extends GetView<PlayerController> {
  const PlaybackLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final progressMs = controller.progressMs.value;
        final trackDuration = controller.trackDuration.value;

        double percent = 0;
        if (trackDuration != null && trackDuration.inMilliseconds > 0) {
          percent = progressMs / trackDuration.inMilliseconds;
        }

        return LinearProgressIndicator(
          value: percent,
          color: Colors.white,
          backgroundColor: Colors.grey.withOpacity(0.5),
        );
      },
    );
  }
}
