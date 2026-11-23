import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiClient {
  static const String baseUrl = 'https://ecom-rs8e.onrender.com/api';

  // The backend is hosted on Render's free tier, so the first request after
  // a period of inactivity can take a long time to wake the server up.
  static const Duration _timeout = Duration(seconds: 60);

  String? _token;

  void setToken(String? token) => _token = token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) ...{
          // The live backend's auth middleware reads a bare `token` header,
          // not the standard `Authorization: Bearer`. Send both so it works
          // regardless of which one the deployed server actually checks.
          'token': _token!,
          'Authorization': 'Bearer $_token',
        },
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanQuery = query == null
        ? null
        : query.map((key, value) => MapEntry(key, value.toString()));
    return Uri.parse('$baseUrl$path').replace(queryParameters: cleanQuery);
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return _send(() => http.get(_uri(path, query), headers: _headers));
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) {
    return _send(() => http.post(_uri(path), headers: _headers, body: jsonEncode(body)));
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) {
    return _send(() => http.patch(_uri(path), headers: _headers, body: jsonEncode(body)));
  }

  Future<Map<String, dynamic>> delete(String path) {
    return _send(() => http.delete(_uri(path), headers: _headers));
  }

  Future<Map<String, dynamic>> _send(Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on TimeoutException {
      throw ApiException('The server is taking too long to respond. Please try again.');
    } on SocketException {
      throw ApiException('Could not reach the server. Check your internet connection.');
    }

    Map<String, dynamic> json;
    try {
      final decoded = response.body.isEmpty ? {} : jsonDecode(response.body);
      json = decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      throw ApiException('Unexpected response from the server.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final msg = json['msg']?.toString() ?? 'Something went wrong. Please try again.';
      throw ApiException(msg);
    }

    return json;
  }
}
