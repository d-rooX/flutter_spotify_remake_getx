import 'package:get/get.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake_getx/abstract/services/auth_service.dart';
import 'package:spotify_remake_getx/abstract/services/credentials_repository.dart';
import 'package:spotify_remake_getx/app.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyAuthService implements AuthService<SpotifyApi> {
  @override
  final CredentialsRepository<SpotifyApiCredentials> credentialsRepository;
  const SpotifyAuthService({required this.credentialsRepository});

  @override
  Future<SpotifyApi> authorize() async {
    var creds = await credentialsRepository.getCredentials();
    if (creds != null) {
      return (await SpotifyApi.asyncFromCredentials(creds));
    }

    creds = SpotifyApiCredentials(
      AppConstants.CLIENT_ID,
      AppConstants.CLIENT_SECRET,
    );
    final grant = SpotifyApi.authorizationCodeGrant(creds);
    final authUri = grant.getAuthorizationUrl(
      Uri.parse(AppConstants.REDIRECT_URL),
      scopes: AppConstants.CLIENT_SCOPES,
    );
    final responseUri = await showAuthWebView(authUri);
    final api = SpotifyApi.fromAuthCodeGrant(grant, responseUri);

    await credentialsRepository.saveCredentials(await api.getCredentials());
    return api;
  }

  Future<String> showAuthWebView(Uri uri) async {
    String? responseURI;

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor()
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(AppConstants.REDIRECT_URL)) {
              responseURI = request.url;
              Get.back();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    await controller.loadRequest(uri);
    Get.showOverlay(
      asyncFunction: () async => WebViewWidget(controller: controller),
    );

    return responseURI!;
  }
}
