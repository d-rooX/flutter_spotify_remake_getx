import 'package:spotify/spotify.dart' as spotify_lib;
import 'package:spotify_sdk/models/track.dart' as spotify_sdk;

extension ToSpotifyLib on spotify_sdk.Track {
  spotify_lib.Track get toSpotifyLib {
    final trackJson = toJson()
      ..update(
        'album',
        (album) => album.toJson(),
      )
      ..update(
        'artists',
        (artists) => artists.map((e) => e.toJson()).toList(growable: false),
      );

    return spotify_lib.Track.fromJson(trackJson);
  }
}
