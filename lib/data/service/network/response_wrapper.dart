// lib/data/service/network/response_wrapper.dart
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
