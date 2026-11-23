import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  final String token;
  final Map<String, dynamic> user;

  AuthSession({required this.token, required this.user});
}

class AuthLocalStorage {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  Future<void> saveSession({required String token, required Map<String, dynamic> user}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<AuthSession?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userRaw = prefs.getString(_userKey);
    if (token == null || userRaw == null) return null;
    try {
      final user = jsonDecode(userRaw) as Map<String, dynamic>;
      return AuthSession(token: token, user: user);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
