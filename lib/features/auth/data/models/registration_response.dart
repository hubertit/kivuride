/// Registration response model from API
class RegistrationResponse {
  final UserData? user;
  final bool verificationRequired;

  const RegistrationResponse({
    this.user,
    required this.verificationRequired,
  });

  /// Create RegistrationResponse from JSON
  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      verificationRequired: json['verificationRequired'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'verificationRequired': verificationRequired,
    };
  }

  @override
  String toString() {
    return 'RegistrationResponse(user: $user, verificationRequired: $verificationRequired)';
  }
}

/// User data model
class UserData {
  final String code;
  final String name;
  final String email;
  final String phone;
  final String accountType;
  final bool isVerified;
  final UserProfile? profile;

  const UserData({
    required this.code,
    required this.name,
    required this.email,
    required this.phone,
    required this.accountType,
    required this.isVerified,
    this.profile,
  });

  /// Create UserData from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      accountType: json['accountType'] ?? '',
      isVerified: json['isVerified'] ?? false,
      profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'email': email,
      'phone': phone,
      'accountType': accountType,
      'isVerified': isVerified,
      'profile': profile?.toJson(),
    };
  }

  /// Create a copy with updated fields
  UserData copyWith({
    String? code,
    String? name,
    String? email,
    String? phone,
    String? accountType,
    bool? isVerified,
    UserProfile? profile,
  }) {
    return UserData(
      code: code ?? this.code,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountType: accountType ?? this.accountType,
      isVerified: isVerified ?? this.isVerified,
      profile: profile ?? this.profile,
    );
  }

  @override
  String toString() {
    return 'UserData(code: $code, name: $name, email: $email, phone: $phone, accountType: $accountType, isVerified: $isVerified, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData &&
        other.code == code &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.accountType == accountType &&
        other.isVerified == isVerified &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        accountType.hashCode ^
        isVerified.hashCode ^
        profile.hashCode;
  }
}

/// User profile data model
class UserProfile {
  final String rating;
  final int totalRides;
  final String memberSince;
  final String? preferredPayment;

  const UserProfile({
    required this.rating,
    required this.totalRides,
    required this.memberSince,
    this.preferredPayment,
  });

  /// Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      rating: json['rating'] ?? '0.00',
      totalRides: json['totalRides'] ?? 0,
      memberSince: json['memberSince'] ?? '',
      preferredPayment: json['preferredPayment'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'totalRides': totalRides,
      'memberSince': memberSince,
      'preferredPayment': preferredPayment,
    };
  }

  @override
  String toString() {
    return 'UserProfile(rating: $rating, totalRides: $totalRides, memberSince: $memberSince, preferredPayment: $preferredPayment)';
  }
}
