abstract interface class AuthService<T> {
  Future<T> authorize();
}
