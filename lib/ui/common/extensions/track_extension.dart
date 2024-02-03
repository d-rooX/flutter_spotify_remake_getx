import 'package:spotify/spotify.dart';

extension TrackExtension on Track {
  String get title {
    final name = this.name;
    if (name == null) throw "No name loaded";
    return name;
  }

  String get bigImageUrl {
    final url = album?.images?.first.url;
    if (url == null) throw "No big image loaded";
    return url;
  }

  String get smallImageUrl {
    final url = album?.images?.elementAt(1).url;
    if (url == null) throw "No small image loaded";
    return url;
  }

  String get formattedArtists {
    final formattedArtists = artists?.map((e) => e.name).join(" | ");
    if (formattedArtists == null) throw "No artists loaded";
    return formattedArtists;
  }
}
