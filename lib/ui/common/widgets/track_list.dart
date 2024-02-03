import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/ui/common/widgets/track_view.dart';

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
