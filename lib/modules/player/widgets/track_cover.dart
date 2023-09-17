import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';

class TrackCover extends GetView<PlayerController> {
  final ImageProvider imageProvider;
  final String trackId;
  const TrackCover({
    super.key,
    required this.imageProvider,
    required this.trackId,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "${trackId}_card",
      child: SizedBox(
        width: 350,
        height: 350,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider),
          ),
        ),
      ),
    );
  }
}
