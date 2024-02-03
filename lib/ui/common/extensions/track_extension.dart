import 'package:spotify/spotify.dart';

extension TrackExtension on Track {
  String? get smallImageUrl => album?.images?.elementAt(1).url;
  String? get formattedArtists => artists?.map((e) => e.name).join(" | ");
}
