import 'dart:developer';

import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/services/auth_service.dart';
import 'package:spotify_remake_getx/abstract/services/credentials_repository.dart';
import 'package:spotify_remake_getx/app_constants.dart';
import 'package:spotify_remake_getx/implementation/services/spotify_api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyAuthService implements AuthService<SpotifyApiService> {
  final CredentialsRepository<SpotifyApiCredentials> credentialsRepository;
  const SpotifyAuthService({required this.credentialsRepository});

  @override
  Future<SpotifyApiService> authorize() async {
    final creds = await credentialsRepository.getCredentials();
    if (creds != null) {
      try {
        final api = await SpotifyApi.asyncFromCredentials(creds);
        return SpotifyApiService(api);
      } catch (e) {
        log(e.toString());
      }
    }

    final grant = SpotifyApi.authorizationCodeGrant(
      SpotifyApiCredentials(
        AppConstants.clientID,
        AppConstants.clientSecret,
      ),
    );
    final authUri = grant.getAuthorizationUrl(
      Uri.parse(AppConstants.redirectURL),
      scopes: AppConstants.clientScopes,
    );
    final responseUri = await showAuthWebView(authUri);
    final api = SpotifyApi.fromAuthCodeGrant(grant, responseUri);

    await credentialsRepository.saveCredentials(await api.getCredentials());
    return SpotifyApiService(api);
  }

  Future<String> showAuthWebView(Uri uri) async {
    String? responseURI;

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(AppConstants.redirectURL)) {
              responseURI = request.url;
              Get.back();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    await controller.loadRequest(uri);
    await Get.dialog(WebViewWidget(controller: controller));

    return responseURI!;
  }
}
