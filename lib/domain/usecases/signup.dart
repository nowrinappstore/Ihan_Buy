import '../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<void> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? city,
    String? address,
  }) {
    return repository.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
      city: city,
      address: address,
    );
  }
}
