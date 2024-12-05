import 'dart:convert';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:http/http.dart' as http;

import '../components/snackbar.dart';
import '../models/booking_request_model.dart';
import '../models/booking_response_model.dart';
import '../url.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final TokenService tokenService = TokenService();

  Future<bool> createBooking(BookingRequest request) async {

    try {
      final token = await tokenService.getToken();

      print(request.toJson());

      final response = await http.post(
        Uri.parse("${URL.baseUrl}User/Booking/Add"),
        headers: {
          'Content-Type': 'application/json-patch+json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      Snackbar.showError( "Error", "Fail to create booking!");
      return false;
    }
  }

  Future<BookingResponse?> getBookings() async {
    try {
      final token = await tokenService.getToken();

      final response = await http.get(
        Uri.parse("${URL.baseUrl}User/Booking/GetPersonalBookings"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        return BookingResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      Snackbar.showError("Error", "Failed to create booking!");
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
  try {
    final token = await tokenService.getToken();

    final response = await http.post(
      Uri.parse("${URL.baseUrl}User/Booking/SendCancelRequest/$bookingId"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    Snackbar.showError("Error", "An error occurred while canceling booking!");
    return false;
  }
}
}