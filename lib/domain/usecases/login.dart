import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<void> call(String email, String password) => repository.login(email, password);
}
