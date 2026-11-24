// lib/data/model/auth_user_model.dart
import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String? id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? city;
  final String? address;

  const AuthUserModel({
    this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.city,
    this.address,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['_id']?.toString(),
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'city': city,
      'address': address,
    };
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      city: city,
      address: address,
    );
  }
}
