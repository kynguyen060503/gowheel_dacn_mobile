import 'booking_model.dart';

class BookingResponse {
  final bool success;
  final String? message;
  final int statusCode;
  final List<Booking> data;

  BookingResponse({
    required this.success,
    this.message,
    required this.statusCode,
    required this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      success: json['success'] ?? false,
      message: json['message'],
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List?)?.map((x) => Booking.fromJson(x)).toList() ?? [],
    );
  }
}
