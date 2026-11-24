// lib/presentation/state/auth_controller.dart
import 'package:flutter/foundation.dart';

import '../../core/app_strings.dart';
import '../../data/service/auth_service.dart';
import '../../data/service/network/response_wrapper.dart';
import '../../domain/entities/auth_user.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service;

  AuthController(this._service);

  String? _pendingEmail;
  String? _pendingPassword;
  bool isLoading = false;
  String? errorMessage;

  AuthUser? get currentUser => _service.currentUser;
  String? get pendingEmail => _pendingEmail;

  /// Call once at startup. Returns true if a persisted session was restored.
  Future<bool> restoreSession() async {
    try {
      return await _service.restoreSession();
    } catch (_) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _service.login(email, password);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotLogIn;
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
      await _service.signup(
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
      errorMessage = AppStrings.errorCouldNotSignUp;
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
      await _service.sendOtp(email);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotSendCode;
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
      final verified = await _service.verifyOtp(email, code);
      if (!verified) {
        errorMessage = AppStrings.errorIncorrectCode;
        return false;
      }

      final password = _pendingPassword;
      if (password != null) {
        await _service.login(email, password);
      }
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = AppStrings.errorCouldNotVerifyCode;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _pendingEmail = null;
    _pendingPassword = null;
    notifyListeners();
  }
}
