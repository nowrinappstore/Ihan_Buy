import '../../core/network/api_client.dart';

class AuthApiDataSource {
  final ApiClient _client;

  AuthApiDataSource(this._client);

  Future<Map<String, dynamic>> login(String email, String password) {
    return _client.post('/auth/login', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? city,
    String? address,
  }) {
    return _client.post('/auth/signup', {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (city != null && city.isNotEmpty) 'city': city,
      if (address != null && address.isNotEmpty) 'address': address,
    });
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) {
    return _client.post('/auth/verify-otp', {'email': email, 'otp': otp});
  }

  Future<Map<String, dynamic>> resendOtp(String email) {
    return _client.post('/auth/resend-otp', {'email': email});
  }
}
