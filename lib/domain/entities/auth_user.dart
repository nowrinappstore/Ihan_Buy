// lib/domain/entities/auth_user.dart
class AuthUser {
  final String? id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? city;
  final String? address;

  const AuthUser({
    this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.city,
    this.address,
  });

  AuthUser copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    String? address,
  }) {
    return AuthUser(
      id: id,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
    );
  }
}
