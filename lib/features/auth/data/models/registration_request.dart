/// Registration request model for API calls
class RegistrationRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String accountType;
  final String countryCode;

  const RegistrationRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.accountType,
    required this.countryCode,
  });

  /// Create RegistrationRequest from form data
  factory RegistrationRequest.fromFormData({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String accountType,
    required String countryCode,
  }) {
    return RegistrationRequest(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
      password: password,
      accountType: accountType,
      countryCode: countryCode,
    );
  }

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'accountType': accountType,
      'countryCode': countryCode,
    };
  }

  /// Create a copy with updated fields
  RegistrationRequest copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? accountType,
    String? countryCode,
  }) {
    return RegistrationRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      accountType: accountType ?? this.accountType,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  String toString() {
    return 'RegistrationRequest(name: $name, email: $email, phone: $phone, accountType: $accountType, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegistrationRequest &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.accountType == accountType &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        accountType.hashCode ^
        countryCode.hashCode;
  }
}
