import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/ui/common/styles/track_view_styles.dart';
import 'package:spotify_remake_getx/ui/modules/player/controllers/player_controller.dart';

class TrackView extends StatelessWidget {
  final Track track;
  const TrackView({required this.track, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          final controller = Get.find<PlayerController>();
          await controller.play(track);
          log("Playing ${track.id!}", name: "TrackView");
        },
        child: Container(
          height: TrackViewStyles.height,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(TrackViewStyles.coverBorderRadius),
                child: CachedNetworkImage(
                  imageUrl: track.album!.images![1].url!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name!,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: TrackViewStyles.titleSize,
                      ),
                    ),
                    Text(
                      track.artists!.map((e) => e.name!).join(" | "),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: TrackViewStyles.titleSize,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                TrackViewStyles.likeIconAsset,
                color: Colors.white,
                size: TrackViewStyles.likeIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
