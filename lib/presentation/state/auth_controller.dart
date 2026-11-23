import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/verify_otp.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  final Login _login;
  final Signup _signup;
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;

  AuthController({
    required AuthRepository repository,
    required Login login,
    required Signup signup,
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
  })  : _repository = repository,
        _login = login,
        _signup = signup,
        _sendOtp = sendOtp,
        _verifyOtp = verifyOtp;

  String? _pendingEmail;
  String? _pendingPassword;
  bool isLoading = false;
  String? errorMessage;

  AuthUser? get currentUser => _repository.currentUser;
  String? get pendingEmail => _pendingEmail;

  /// Call once at startup. Returns true if a persisted session was restored.
  Future<bool> restoreSession() async {
    try {
      return await _repository.restoreSession();
    } catch (_) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _login(email, password);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not log in. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? city,
    String? address,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _signup(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        city: city,
        address: address,
      );
      _pendingEmail = email;
      _pendingPassword = password;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not sign up. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendOtp(String email) async {
    _pendingEmail = email;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _sendOtp(email);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not send the code. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Verifies the OTP, then logs in with the password captured during signup
  /// so a token is obtained without asking the user to log in again.
  Future<bool> verifyOtp(String code) async {
    final email = _pendingEmail;
    if (email == null) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final verified = await _verifyOtp(email, code);
      if (!verified) {
        errorMessage = 'Incorrect code. Please try again.';
        return false;
      }

      final password = _pendingPassword;
      if (password != null) {
        await _login(email, password);
      }
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Could not verify the code. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _pendingEmail = null;
    _pendingPassword = null;
    notifyListeners();
  }
}
