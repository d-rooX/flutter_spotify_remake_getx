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
      body: GetX<PlayerController>(
        builder: (controller) {
          if (controller.currentTrack.value == null) {
            return const CircularProgressIndicator();
          }
          return _LoadedPlayerPage(track: controller.currentTrack.value!);
        },
      ),
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
    final paletteColors = await Utils.getImagePalette(imageProvider!);
    controller!.paletteColors.assignAll(paletteColors.map((e) => e.color));
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: Colors.white,
                    ),
                    Text("something here", style: TextStyle(fontSize: 16)),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 34,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                _TrackCover(imageProvider: imageProvider!),
                const SizedBox(height: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.track.name!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.track.artists!
                                    .map((e) => e.name!)
                                    .join(", "),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.circle_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
