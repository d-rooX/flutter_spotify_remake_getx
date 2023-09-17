import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';
import 'package:spotify_remake_getx/utils.dart';

class PlayerPage extends GetView<PlayerController> {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.playbackState.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _LoadedPlayerPage(track: controller.playbackState.value!.item!);
      }),
    );
  }
}

class _LoadedPlayerPage extends StatefulWidget {
  final Track track;
  const _LoadedPlayerPage({required this.track});

  @override
  State<_LoadedPlayerPage> createState() => _LoadedPlayerPageState();
}

class _LoadedPlayerPageState extends State<_LoadedPlayerPage> {
  PlayerController? controller;
  Track? oldTrack;
  CachedNetworkImageProvider? imageProvider;

  @override
  void initState() {
    oldTrack = widget.track;
    controller = Get.find<PlayerController>();
    loadImage();

    super.initState();
  }

  void loadImage() async {
    setState(() {
      imageProvider = CachedNetworkImageProvider(
        widget.track.album!.images![0].url!,
      );
    });
    final paletteColors = <Color>[];
    for (final color in await Utils.getImagePalette(imageProvider!)) {
      Color _color = color.color;
      if (_color.computeLuminance() > 0.5) {
        _color = _color.withOpacity(0.7);
      }
      paletteColors.add(_color);
    }

    controller!.paletteColors.assignAll(paletteColors);
  }

  @override
  Widget build(BuildContext context) {
    if (oldTrack != widget.track) {
      oldTrack = widget.track;
      loadImage();
    }

    return SizedBox.expand(
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            gradient: controller!.paletteColors.isNotEmpty
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: controller!.paletteColors.take(2).toList(),
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
                _TrackCover(imageProvider: imageProvider!),
                const SizedBox(height: 40),
                PlayerBottom(track: widget.track)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerTop extends StatelessWidget {
  const PlayerTop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          CupertinoIcons.chevron_down,
          color: Colors.white,
        ),
        Text(
          "dont look at this shit bro",
          style: TextStyle(fontSize: 16),
        ),
        Icon(
          Icons.more_horiz,
          color: Colors.white,
          size: 34,
        ),
      ],
    );
  }
}

class PlayerBottom extends StatelessWidget {
  final Track track;
  const PlayerBottom({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
          ),
          const SizedBox(height: 20),
          GetX<PlayerController>(
            builder: (controller) {
              final currentMinutes =
                  "${controller.progressMs.value ~/ 60000}:${controller.progressMs.value ~/ 1000}";

              final duration = controller.trackDuration.value!;
              final durationString =
                  "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currentMinutes),
                  Text(durationString),
                ],
              );
            },
          ),
          const PlaybackLine(),
        ],
      ),
    );
  }
}

class PlaybackLine extends GetView<PlayerController> {
  const PlaybackLine({super.key});

  @override
  Widget build(BuildContext context) {
    controller.refreshTrackDuration();

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

///////////////////////////////

class _TrackCover extends StatelessWidget {
  final CachedNetworkImageProvider imageProvider;
  const _TrackCover({required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 350,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider),
        ),
      ),
    );
  }
}
