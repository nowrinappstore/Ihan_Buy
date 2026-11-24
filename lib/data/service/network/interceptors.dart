// lib/data/service/network/interceptors.dart
class AuthHeaderInterceptor {
  AuthHeaderInterceptor._();

  /// The live backend's auth middleware reads a bare `token` header, not the
  /// standard `Authorization: Bearer`. Send both so it works regardless of
  /// which one the deployed server actually checks.
  static Map<String, String> headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) ...{
        'token': token,
        'Authorization': 'Bearer $token',
      },
    };
  }
}
