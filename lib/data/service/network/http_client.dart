// lib/data/service/network/http_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/end_points.dart';
import 'interceptors.dart';
import 'response_wrapper.dart';

class HttpClient {
  // The backend is hosted on Render's free tier, so the first request after
  // a period of inactivity can take a long time to wake the server up.
  static const Duration _timeout = Duration(seconds: 60);

  String? _token;

  void setToken(String? token) => _token = token;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanQuery = query?.map((key, value) => MapEntry(key, value.toString()));
    return Uri.parse('${EndPoints.baseUrl}$path').replace(queryParameters: cleanQuery);
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return _send(() => http.get(_uri(path, query), headers: AuthHeaderInterceptor.headers(_token)));
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) {
    return _send(
      () => http.post(_uri(path), headers: AuthHeaderInterceptor.headers(_token), body: jsonEncode(body)),
    );
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) {
    return _send(
      () => http.patch(_uri(path), headers: AuthHeaderInterceptor.headers(_token), body: jsonEncode(body)),
    );
  }

  Future<Map<String, dynamic>> delete(String path) {
    return _send(() => http.delete(_uri(path), headers: AuthHeaderInterceptor.headers(_token)));
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
