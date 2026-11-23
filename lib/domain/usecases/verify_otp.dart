import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<bool> call(String email, String code) => repository.verifyOtp(email, code);
}
