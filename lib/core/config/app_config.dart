/// KivuRide App Configuration
/// Centralized configuration management for the entire app
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // Environment types
  static const String _development = 'development';
  static const String _staging = 'staging';
  static const String _production = 'production';

  // Current environment - change this to switch environments
  static const String _currentEnvironment = _production;

  // Base URLs for different environments
  static const Map<String, String> _baseUrls = {
    _development: 'http://localhost:3000/api/v1',
    _staging: 'http://staging-api.kivuride.rw/api/v1',
    _production: 'http://167.71.157.112/api/v1',
  };

  // API Configuration
  static String get baseUrl => _baseUrls[_currentEnvironment]!;
  static String get environment => _currentEnvironment;
  static bool get isDevelopment => _currentEnvironment == _development;
  static bool get isStaging => _currentEnvironment == _staging;
  static bool get isProduction => _currentEnvironment == _production;

  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String driversEndpoint = '/drivers';
  static const String ridesEndpoint = '/rides';
  static const String paymentsEndpoint = '/payments';
  static const String notificationsEndpoint = '/notifications';
  static const String locationEndpoint = '/location';

  // Authentication Configuration
  static const String jwtTokenKey = 'kivuride_jwt_token';
  static const String refreshTokenKey = 'kivuride_refresh_token';
  static const String userDataKey = 'kivuride_user_data';
  static const String deviceInfoKey = 'kivuride_device_info';
  
  // Token expiration times (in seconds)
  static const int accessTokenExpiration = 3600; // 1 hour
  static const int refreshTokenExpiration = 604800; // 7 days

  // API Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;

  // Rate Limiting
  static const int maxRetryAttempts = 3;
  static const int retryDelayMs = 1000;

  // Location Configuration
  static const double defaultLatitude = -1.9441; // Kigali center
  static const double defaultLongitude = 30.0619; // Kigali center
  static const double locationUpdateInterval = 5000; // 5 seconds
  static const double locationAccuracyThreshold = 100; // 100 meters

  // Map Configuration
  static const String googleMapsApiKey = 'AIzaSyDxBhRITQxdhqgvo2FP5GkY_OI0hdeKvyg';
  static const double defaultZoomLevel = 15.0;
  static const double minZoomLevel = 10.0;
  static const double maxZoomLevel = 20.0;

  // Ride Configuration
  static const Map<String, double> rideTypeBasePrices = {
    'standard': 2500.0,
    'premium': 3500.0,
    'xl': 4500.0,
  };

  static const Map<String, double> rideTypePricePerKm = {
    'standard': 800.0,
    'premium': 1200.0,
    'xl': 1500.0,
  };

  // Payment Configuration
  static const List<String> supportedPaymentMethods = [
    'mobile_money',
    'card',
    'cash',
    'wallet',
  ];

  static const List<String> mobileMoneyProviders = [
    'mtn',
    'airtel',
    'tigo',
  ];

  // Currency Configuration
  static const String defaultCurrency = 'RWF';
  static const String currencySymbol = 'RWF';

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 255;
  static const String phonePattern = r'^\+250[0-9]{9}$';
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // UI Configuration
  static const int animationDuration = 300; // milliseconds
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const int splashDuration = 3000; // milliseconds
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 56.0;

  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String timeoutErrorMessage = 'Request timeout. Please try again.';
  static const String unauthorizedErrorMessage = 'Session expired. Please login again.';
  static const String validationErrorMessage = 'Please check your input and try again.';

  // Success Messages
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String loginSuccessMessage = 'Welcome back!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String rideRequestSuccessMessage = 'Ride requested successfully!';
  static const String paymentSuccessMessage = 'Payment processed successfully!';

  // App Information
  static const String appName = 'KivuRide';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription = 'Rwanda\'s premier ride-sharing platform';

  // Contact Information
  static const String supportEmail = 'support@kivuride.rw';
  static const String supportPhone = '+250788000000';
  static const String websiteUrl = 'https://kivuride.rw';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/kivuride';
  static const String twitterUrl = 'https://twitter.com/kivuride';
  static const String instagramUrl = 'https://instagram.com/kivuride';

  // Legal
  static const String privacyPolicyUrl = 'https://kivuride.rw/privacy';
  static const String termsOfServiceUrl = 'https://kivuride.rw/terms';

  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableLocationTracking = true;
  static const bool enableBiometricAuth = false;
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = false;

  // Debug Configuration
  static bool get enableLogging => isDevelopment;
  static bool get enableApiLogging => isDevelopment;
  static bool get enableCrashReporting => isProduction;

  // Helper methods
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  static String getAuthUrl(String endpoint) {
    return '$baseUrl$authEndpoint$endpoint';
  }

  static String getUsersUrl(String endpoint) {
    return '$baseUrl$usersEndpoint$endpoint';
  }

  static String getDriversUrl(String endpoint) {
    return '$baseUrl$driversEndpoint$endpoint';
  }

  static String getRidesUrl(String endpoint) {
    return '$baseUrl$ridesEndpoint$endpoint';
  }

  static String getPaymentsUrl(String endpoint) {
    return '$baseUrl$paymentsEndpoint$endpoint';
  }

  static String getNotificationsUrl(String endpoint) {
    return '$baseUrl$notificationsEndpoint$endpoint';
  }

  static String getLocationUrl(String endpoint) {
    return '$baseUrl$locationEndpoint$endpoint';
  }

  // Validation helpers
  static bool isValidEmail(String email) {
    return RegExp(emailPattern).hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(phonePattern).hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength && password.length <= maxPasswordLength;
  }

  // Environment switching helper
  static void switchEnvironment(String environment) {
    if (_baseUrls.containsKey(environment)) {
      // Note: In a real app, you might want to use a more sophisticated
      // approach like dependency injection or a configuration service
      throw UnsupportedError('Environment switching not supported in runtime. Change _currentEnvironment constant.');
    }
  }

  // Print configuration for debugging
  static void printConfig() {
    if (enableLogging) {
      print('=== KivuRide App Configuration ===');
      print('Environment: $environment');
      print('Base URL: $baseUrl');
      print('App Version: $appVersion');
      print('Debug Logging: $enableLogging');
      print('API Logging: $enableApiLogging');
      print('================================');
    }
  }
}