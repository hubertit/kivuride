import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException(message: $message, statusCode: $statusCode, errorCode: $errorCode)';
  }
}

/// API Client for handling HTTP requests
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  /// Initialize the API client
  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConfig.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// Get the Dio instance
  Dio get dio => _dio;

  /// Make a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Make a POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Make a PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Make a DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
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
        if (e.error is SocketException) {
          message = AppConfig.networkErrorMessage;
        } else {
          message = 'An unexpected error occurred';
        }
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

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.enableApiLogging) {
      print('🚀 API Request: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('📤 Request Data: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('🔍 Query Parameters: ${options.queryParameters}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.enableApiLogging) {
      print('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
      if (response.data != null) {
        print('📥 Response Data: ${response.data}');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.enableApiLogging) {
      print('❌ API Error: ${err.type} ${err.requestOptions.uri}');
      print('💥 Error Message: ${err.message}');
      if (err.response?.data != null) {
        print('📥 Error Response: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}

/// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error cases
    if (err.response?.statusCode == 401) {
      // Handle unauthorized access
      // You might want to clear stored tokens here
    } else if (err.response?.statusCode == 403) {
      // Handle forbidden access
    } else if (err.response?.statusCode == 404) {
      // Handle not found
    } else if (err.response?.statusCode == 500) {
      // Handle server error
    }

    super.onError(err, handler);
  }
}
