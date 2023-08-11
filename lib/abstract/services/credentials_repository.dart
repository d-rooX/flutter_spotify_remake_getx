abstract interface class CredentialsRepository<T> {
  Future<void> saveCredentials(T credentials);
  Future<T?> getCredentials();
}
