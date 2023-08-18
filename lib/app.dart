import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppConstants {
  static const CLIENT_ID = "faec7ac92a714a359b4dbafba1b04e1a";
  static const CLIENT_SECRET = "3f5e0244b87140b49e6f75811185f076";
  static const REDIRECT_URL = "https://spotapi.droox.dev/callback";
  static const CLIENT_SCOPES = [
    'user-read-recently-played',
    'user-read-private',
    'user-top-read',
    'user-library-read',
    'playlist-read-private',
    'playlist-read-collaborative',
  ];
}
