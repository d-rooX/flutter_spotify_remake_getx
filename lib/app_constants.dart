class AppConstants {
  static const clientID = "faec7ac92a714a359b4dbafba1b04e1a";
  static const clientSecret = "3f5e0244b87140b49e6f75811185f076";
  static const redirectURL = "https://spotapi.droox.dev/callback";
  static const clientScopes = [
    'user-read-recently-played',
    'user-read-private',
    'user-top-read',
    'user-library-read',
    'user-modify-playback-state',
    'user-read-playback-state',
    'user-read-currently-playing',

    ///
    'playlist-read-private',
    'playlist-read-collaborative',
  ];
}
