import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/services/credentials_repository.dart';
import 'package:spotify_remake_getx/app.dart';

class SpotifyCredentialsRepository
    implements CredentialsRepository<SpotifyApiCredentials> {
  @override
  Future<SpotifyApiCredentials?> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    final expiration = prefs.getInt('expiration');
    final scopes = prefs.getStringList('scopes');

    if ([accessToken, refreshToken, scopes].any((element) => element == null)) {
      return null;
    }
    Function eq = const ListEquality().equals;

    if (!eq(AppConstants.CLIENT_SCOPES, scopes)) {
      log("DIFFERENT SCOPES", name: "Authentication");
      return null;
    }

    return SpotifyApiCredentials(
      AppConstants.CLIENT_ID,
      AppConstants.CLIENT_SECRET,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiration: DateTime.fromMillisecondsSinceEpoch(expiration!),
      scopes: scopes,
    );
  }

  @override
  Future<void> saveCredentials(SpotifyApiCredentials credentials) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('accessToken', credentials.accessToken!);
    await prefs.setString('refreshToken', credentials.refreshToken!);
    await prefs.setInt(
      'expiration',
      credentials.expiration!.millisecondsSinceEpoch,
    );
    await prefs.setStringList('scopes', credentials.scopes!);
  }
}
