import 'package:flutter/material.dart' show BuildContext;
import 'package:spotify_remake_getx/abstract/services/credentials_repository.dart';

import 'api_service.dart';

abstract class AuthService {
  final CredentialsRepository credentialsRepository;
  const AuthService({required this.credentialsRepository});

  Future<AuthService?> fromSavedCredentials() {}

  Future<SpotifyApi> authorize() async {
    SpotifyApi? api = await fromSavedCredentials();
    api ??= await fromAuthWebView();
    return api;
  }
}
