import 'package:dio/dio.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/registration_request.dart';
import '../models/registration_response.dart';
import '../models/login_response.dart';
import '../models/api_response.dart';

/// Authentication service for handling auth-related API calls
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final ApiClient _apiClient;

  /// Initialize the auth service
  void initialize() {
    _apiClient = ApiClient();
    _apiClient.initialize();
  }

  /// Register a new user
  Future<ApiResponse<RegistrationResponse>> register(RegistrationRequest request) async {
    try {
      final response = await _apiClient.post(
        AppConfig.getAuthUrl('/register'),
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<RegistrationResponse>.fromJson(
        response.data,
        (data) => RegistrationResponse.fromJson(data),
      );

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.errorMessage,
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Registration failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Login user with email/phone and password
  Future<ApiResponse<LoginResponse>> login({
    required String identifier,
    required String password,
    required Map<String, dynamic> deviceInfo,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.getAuthUrl('/login'),
        data: {
          'identifier': identifier,
          'password': password,
          'deviceInfo': deviceInfo,
        },
      );

      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (data) => LoginResponse.fromJson(data),
      );

      // Debug logging
      if (AppConfig.enableApiLogging) {
        print('🔍 Login API Response: ${apiResponse.status}, Code: ${apiResponse.code}, Message: ${apiResponse.message}');
        print('🔍 Is Success: ${apiResponse.isSuccess}, Is Error: ${apiResponse.isError}');
      }

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.message.isNotEmpty ? apiResponse.message : 'Login failed',
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Login failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Verify phone number with OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyPhone({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.getAuthUrl('/verify-phone'),
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data,
      );

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.errorMessage,
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Phone verification failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Request password reset
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String identifier,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.getAuthUrl('/forgot-password'),
        data: {
          'identifier': identifier,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data,
      );

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.errorMessage,
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Password reset request failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Reset password with token
  Future<ApiResponse<Map<String, dynamic>>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.getAuthUrl('/reset-password'),
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data,
      );

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.errorMessage,
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Password reset failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get current user profile
  Future<ApiResponse<Map<String, dynamic>>> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        AppConfig.getAuthUrl('/me'),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data,
      );

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.errorMessage,
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Failed to get user profile: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Logout user
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await _apiClient.post(
        AppConfig.getAuthUrl('/logout'),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data,
      );

      if (!apiResponse.isSuccess) {
        throw ApiException(
          message: apiResponse.errorMessage,
          statusCode: apiResponse.code,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'Logout failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Handle Dio exceptions and convert to ApiException
  ApiException _handleDioException(DioException e) {
    String message;
    int? statusCode;
    String? errorCode;
    Map<String, dynamic>? details;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = AppConfig.timeoutErrorMessage;
        break;
      case DioExceptionType.badResponse:
        statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? 'Server error occurred';
          errorCode = responseData['errorCode'];
          details = responseData['details'];
        } else {
          message = 'Server error occurred';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = AppConfig.networkErrorMessage;
        break;
      case DioExceptionType.badCertificate:
        message = 'Certificate error occurred';
        break;
      case DioExceptionType.unknown:
        message = 'An unexpected error occurred';
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      errorCode: errorCode,
      details: details,
    );
  }
}
