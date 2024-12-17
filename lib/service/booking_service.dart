import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gowheel_flutterflow_ui/models/booking_model.dart';
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

  Future<List<DateTimeRange>> getBookedDateRanges(int postId) async {
  try {
    final token = await tokenService.getToken();
    final response = await http.get(
      Uri.parse("${URL.baseUrl}User/Booking/GetAllBookedDates/$postId"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        final List<dynamic> dates = jsonResponse['data'];
        List<DateTimeRange> bookedRanges = [];

        // Convert the date strings into DateTime objects
        for (int i = 0; i < dates.length; i += 2) {
          if (i + 1 < dates.length) {
            try {
              DateTime startDate = DateTime.parse(dates[i]);
              DateTime endDate = DateTime.parse(dates[i + 1]);
              bookedRanges.add(DateTimeRange(start: startDate, end: endDate));
            } catch (e) {
              print('Error parsing date range: $e');
              // Skip this invalid date pair
              continue;
            }
          }
        }
        return bookedRanges;
      } else {
        print('API response success flag is false or data is null.');
        return [];
      }
    } else if (response.statusCode == 404) {
      print('Error 404: The requested resource was not found.');
    } else {
      print('Error: Unexpected status code ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching booked date ranges: $e');
  }
  return [];
}

  Future<Booking?> getBookingById(int bookingId) async {
    try {
      final token = await tokenService.getToken();

      final response = await http.get(
        Uri.parse("${URL.baseUrl}User/Booking/GetById/$bookingId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        return Booking.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print(e);
      Snackbar.showError("Error", "Failed to load personal booking!");
      return null;
    }
  }

  Future<BookingResponse?> getPendingBookingsByUserId() async {
    try {
      final token = await tokenService.getToken();

      final response = await http.get(
        Uri.parse("${URL.baseUrl}User/Booking/GetAllPendingBookingsByUserId"),
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
}