import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';
import 'package:spotify_remake_getx/modules/player/player_page.dart';
import 'package:spotify_remake_getx/utils.dart';

class BigTrackCard extends StatefulWidget {
  final Track track;
  const BigTrackCard({super.key, required this.track});

  @override
  State<BigTrackCard> createState() => _BigTrackCardState();
}

class _BigTrackCardState extends State<BigTrackCard> {
  List<PaletteColor>? paletteColors;
  TextStyle textStyle = const TextStyle(color: Colors.white);

  // used for smoothly animate between tabs
  Track? oldTrack;

  @override
  Widget build(BuildContext context) {
    final imageProvider =
        CachedNetworkImageProvider(widget.track.album!.images![1].url!);

    // Generating colors for title & artist block
    if (paletteColors == null || oldTrack != widget.track) {
      oldTrack = widget.track;
      Utils.getImagePalette(imageProvider).then(
        (value) => setState(() {
          paletteColors = value;

          final textColor = paletteColors![0].color.computeLuminance() < 0.45
              ? Colors.white.withOpacity(0.65)
              : Colors.black;

          textStyle = TextStyle(
            color: paletteColors != null ? textColor : Colors.white,
          );
        }),
      );
    }

    return GestureDetector(
      onTap: () async {
        final controller = Get.find<PlayerController>();
        if (controller.currentTrack.value!.id! != widget.track.id!) {
          await controller.play(widget.track);
        }
        Get.to(() => PlayerPage(openedTrackImageProvider: imageProvider));
      },
      child: Hero(
        tag: "${widget.track.id!}_card",
        child: Container(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.more_horiz, color: Colors.white, size: 36),
              BlurredTrackInfo(
                paletteColors: paletteColors,
                textStyle: textStyle,
                track: widget.track,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BlurredTrackInfo extends StatelessWidget {
  const BlurredTrackInfo({
    super.key,
    required this.paletteColors,
    required this.textStyle,
    required this.track,
  });

  final List<PaletteColor>? paletteColors;
  final TextStyle textStyle;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AnimatedContainer(
          curve: Curves.easeOut,
          duration: const Duration(seconds: 1),
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: double.maxFinite,
          decoration: paletteColors != null
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: paletteColors!
                        .take(2)
                        .map((e) => e.color.withAlpha(180))
                        .toList(),
                  ),
                )
              : null,
          child: SizedBox.expand(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: textStyle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name!,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      inherit: true,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${track.artists!.first.name!} - ${track.album!.name!}",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
