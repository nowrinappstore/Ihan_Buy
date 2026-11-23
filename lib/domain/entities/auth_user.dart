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

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
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
