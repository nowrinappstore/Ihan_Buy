// lib/data/service/auth_service.dart
import '../../core/end_points.dart';
import '../../domain/entities/auth_user.dart';
import '../model/auth_user_model.dart';
import 'cache/cache_service.dart';
import 'network/http_client.dart';
import 'network/response_wrapper.dart';

class AuthService {
  final HttpClient _client;
  final CacheService _cache;

  AuthService(this._client, this._cache);

  AuthUser? _currentUser;
  String? _token;

  AuthUser? get currentUser => _currentUser;
  String? get token => _token;

  /// Loads a previously persisted session (if any) so the user stays logged
  /// in across app restarts. Returns true if a session was restored.
  Future<bool> restoreSession() async {
    final token = await _cache.loadToken();
    final userJson = await _cache.loadUser();
    if (token == null || userJson == null) return false;
    _token = token;
    _currentUser = AuthUserModel.fromJson(userJson).toEntity();
    _client.setToken(token);
    return true;
  }

  Future<AuthUser> login(String email, String password) async {
    final json = await _client.post(EndPoints.login, {'email': email, 'password': password});
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final token = data['token']?.toString();
    final userJson = data['user'] as Map<String, dynamic>?;
    if (token == null || userJson == null) {
      throw ApiException('Unexpected login response from the server.');
    }

    _token = token;
    _currentUser = AuthUserModel.fromJson(userJson).toEntity();
    _client.setToken(token);
    await _cache.saveToken(token);
    await _cache.saveUser(userJson);
    return _currentUser!;
  }

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? city,
    String? address,
  }) {
    return _client.post(EndPoints.signup, {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (city != null && city.isNotEmpty) 'city': city,
      if (address != null && address.isNotEmpty) 'address': address,
    });
  }

  Future<void> sendOtp(String email) => resendOtp(email);

  Future<void> resendOtp(String email) {
    return _client.post(EndPoints.resendOtp, {'email': email});
  }

  Future<bool> verifyOtp(String email, String otp) async {
    await _client.post(EndPoints.verifyOtp, {'email': email, 'otp': otp});
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    _client.setToken(null);
    await _cache.clearSession();
  }
}
