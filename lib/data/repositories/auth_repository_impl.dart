import '../../core/network/api_client.dart';
import '../../core/storage/auth_local_storage.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _dataSource;
  final ApiClient _client;
  final AuthLocalStorage _storage;

  AuthRepositoryImpl(this._dataSource, this._client, this._storage);

  AuthUser? _currentUser;
  String? _token;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  String? get token => _token;

  @override
  Future<bool> restoreSession() async {
    final session = await _storage.loadSession();
    if (session == null) return false;
    _token = session.token;
    _currentUser = AuthUser.fromJson(session.user);
    _client.setToken(_token);
    return true;
  }

  @override
  Future<void> login(String email, String password) async {
    final json = await _dataSource.login(email, password);
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final token = data['token']?.toString();
    final userJson = data['user'] as Map<String, dynamic>?;
    if (token == null || userJson == null) {
      throw ApiException('Unexpected login response from the server.');
    }

    _token = token;
    _currentUser = AuthUser.fromJson(userJson);
    _client.setToken(token);
    await _storage.saveSession(token: token, user: userJson);
  }

  @override
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? city,
    String? address,
  }) async {
    await _dataSource.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
      city: city,
      address: address,
    );
  }

  @override
  Future<void> resendOtp(String email) => _dataSource.resendOtp(email);

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    await _dataSource.verifyOtp(email, otp);
    return true;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    _client.setToken(null);
    await _storage.clearSession();
  }
}
