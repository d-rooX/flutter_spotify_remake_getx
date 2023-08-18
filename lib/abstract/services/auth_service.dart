import 'package:spotify_remake_getx/abstract/services/credentials_repository.dart';

abstract interface class AuthService<T> {
  final CredentialsRepository credentialsRepository;
  const AuthService({required this.credentialsRepository});

  Future<T> authorize();
}
