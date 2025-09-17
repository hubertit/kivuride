/// Standard API response model that matches the backend response format
class ApiResponse<T> {
  final String status;
  final int code;
  final String message;
  final T? data;

  const ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  /// Check if response is successful
  bool get isSuccess => status == 'success' && code >= 200 && code < 300;

  /// Check if response is an error
  bool get isError => status == 'error' || code >= 400;

  /// Get error message
  String get errorMessage => isError ? message : '';

  @override
  String toString() {
    return 'ApiResponse(status: $status, code: $code, message: $message, data: $data)';
  }
}

/// Pagination metadata model
class PaginationData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  /// Create PaginationData from JSON
  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }

  @override
  String toString() {
    return 'PaginationData(page: $page, limit: $limit, total: $total, totalPages: $totalPages, hasNext: $hasNext, hasPrev: $hasPrev)';
  }
}

/// Paginated API response model
class PaginatedApiResponse<T> {
  final String status;
  final int code;
  final String message;
  final List<T> items;
  final PaginationData pagination;

  const PaginatedApiResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.items,
    required this.pagination,
  });

  /// Create PaginatedApiResponse from JSON
  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final items = (data['items'] as List<dynamic>? ?? [])
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();
    final pagination = PaginationData.fromJson(data['pagination'] ?? {});

    return PaginatedApiResponse<T>(
      status: json['status'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      items: items,
      pagination: pagination,
    );
  }

  /// Check if response is successful
  bool get isSuccess => status == 'success' && code >= 200 && code < 300;

  /// Check if response is an error
  bool get isError => status == 'error' || code >= 400;

  /// Get error message
  String get errorMessage => isError ? message : '';

  @override
  String toString() {
    return 'PaginatedApiResponse(status: $status, code: $code, message: $message, items: ${items.length}, pagination: $pagination)';
  }
}
