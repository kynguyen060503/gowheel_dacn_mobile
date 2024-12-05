class ApiResponse {
  final bool success;
  final String message;
  final int statusCode;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: json['data'],
    );
  }
}
