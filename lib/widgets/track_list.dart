import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/modules/player/controllers/player_controller.dart';

class TrackList extends StatelessWidget {
  final List<Track> tracks;
  const TrackList({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        tracks.length,
        (index) => TrackView(
          track: tracks[index],
        ),
      ),
    );
  }
}

class TrackView extends StatelessWidget {
  final Track track;
  const TrackView({super.key, required this.track});

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
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: track.album!.images![1].url!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name!,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      track.artists!.map((e) => e.name!).join(" | "),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
