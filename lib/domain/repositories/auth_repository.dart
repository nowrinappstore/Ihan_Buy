import '../entities/auth_user.dart';

abstract class AuthRepository {
  AuthUser? get currentUser;
  String? get token;

  /// Loads a previously persisted session (if any) so the user stays logged
  /// in across app restarts. Returns true if a session was restored.
  Future<bool> restoreSession();

  Future<void> login(String email, String password);

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? city,
    String? address,
  });

  Future<void> resendOtp(String email);
  Future<bool> verifyOtp(String email, String otp);

  Future<void> logout();
}
