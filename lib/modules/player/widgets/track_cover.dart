import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrackCover extends StatelessWidget {
  final CachedNetworkImageProvider imageProvider;
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
        child: CachedNetworkImage(
          // using url here not imageProvider to use useOldImageOnUrlChange: true
          imageUrl: imageProvider.url,
          useOldImageOnUrlChange: true,
        ),
      ),
    );
  }
}
