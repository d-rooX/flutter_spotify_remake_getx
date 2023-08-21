import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';

class BigTrackCard extends StatefulWidget {
  final Track track;
  const BigTrackCard({super.key, required this.track});

  @override
  State<BigTrackCard> createState() => _BigTrackCardState();
}

class _BigTrackCardState extends State<BigTrackCard> {
  List<PaletteColor>? paletteColors;
  TextStyle textStyle = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final imageProvider =
        CachedNetworkImageProvider(widget.track.album!.images![1].url!);
    if (paletteColors == null) {
      getImagePalette(imageProvider).then(
        (value) {
          setState(() => paletteColors = value);

          // final ColorTween tween = ColorTween(
          //   begin: paletteColors![0].color,
          //   end: paletteColors![2].color,
          // );
          // final betweenColor = tween.transform(0.5)!;

          final textColor = paletteColors![0].color.computeLuminance() < 0.50
              ? Colors.white.withOpacity(0.65)
              : Colors.black;
          textStyle = TextStyle(
            color: paletteColors != null ? textColor : Colors.white,
          );
        },
      );
    }

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.more_horiz, color: Colors.white, size: 36),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.track.name!,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${widget.track.artists!.first.name!} - ${widget.track.album!.name!}",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Future<List<PaletteColor>> getImagePalette(
    ImageProvider imageProvider,
  ) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.paletteColors;
  }
}
