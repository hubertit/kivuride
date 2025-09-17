import 'registration_response.dart';

/// Login response model from API
class LoginResponse {
  final UserData user;
  final TokenData tokens;

  const LoginResponse({
    required this.user,
    required this.tokens,
  });

  /// Create LoginResponse from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserData.fromJson(json['user']),
      tokens: TokenData.fromJson(json['tokens']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
    };
  }

  @override
  String toString() {
    return 'LoginResponse(user: $user, tokens: $tokens)';
  }
}

/// Token data model
class TokenData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const TokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  /// Create TokenData from JSON
  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }

  @override
  String toString() {
    return 'TokenData(accessToken: ${accessToken.substring(0, 20)}..., refreshToken: ${refreshToken.substring(0, 20)}..., expiresIn: $expiresIn)';
  }
}

