class AppConfig {
  // App Information
  static const String appName = 'KivuRide';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Splash Screen
  static const int splashDuration = 3000; // 3 seconds
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // API Configuration (for future use)
  static const String baseUrl = 'https://api.kivuride.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableBiometricAuth = false;
}
