import 'dart:convert';
import 'package:http/http.dart' as http;
import '../url.dart';
import '../models/driver_booking_model.dart';
import './storage_service.dart';
import '../components/snackbar.dart';

class DriverBookingService {
  static final DriverBookingService _instance = DriverBookingService._internal();
  factory DriverBookingService() => _instance;
  DriverBookingService._internal();

  final TokenService tokenService = TokenService();

  Future<List<DriverBooking>?> getBookingsInRange(double longitude, double latitude) async {
    try {
      final token = await tokenService.getToken();
      
      final response = await http.get(
        Uri.parse("${URL.baseUrl}User/Booking/GetAllBookingsInRange/$latitude&&$longitude"),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'text/plain'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          List jsonList = jsonResponse['data'];
          return jsonList.map((json) => DriverBooking.fromJson(json)).toList();
        }
      }
      return null;
    } catch (e) {
      Snackbar.showError("Error", "Failed to fetch bookings!");
      return null;
    }
  }

  Future<bool> acceptBooking(int bookingId) async {
    try {
      final token = await tokenService.getToken();
      
      final response = await http.post(
        Uri.parse("${URL.baseUrl}DriverBooking/AddDriverBooking/$bookingId"),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'text/plain',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          Snackbar.showSuccess("Success", "Booking accepted successfully!");
          return true;
        } else {
          Snackbar.showError("Error", jsonResponse['message'] ?? "Failed to accept booking");
          return false;
        }
      } else {
        Snackbar.showError("Error", "Failed to accept booking. Please try again.");
        return false;
      }
    } catch (e) {
      Snackbar.showError("Error", "An error occurred while accepting the booking");
      return false;
    }
  }
}