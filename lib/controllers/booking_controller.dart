import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../models/booking_request_model.dart';
import '../service/booking_service.dart';

class BookingController extends GetxController {
  final BookingService _bookingService = BookingService();
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxList<DateTime> bookedDates = <DateTime>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = ''.obs;
  final Rxn<Booking> booking = Rxn<Booking>();

  List<dynamic> get filteredBookings {
    if (selectedStatus.value.isEmpty) {
      return bookings;
    }
    return bookings.where((booking) =>
        booking.status.toLowerCase() == selectedStatus.value.toLowerCase()
    ).toList();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final response = await _bookingService.getBookings();
      if (response != null && response.success) {
        bookings.assignAll(response.data);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch bookings.",
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error fetching bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPendingBookingsByUserId() async {
    try {
      isLoading.value = true;
      final response = await _bookingService.getPendingBookingsByUserId();
      if (response != null && response.success) {
        bookings.assignAll(response.data);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch pending bookings.",
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error fetching pending bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Booking?> fetchBookingById(int bookingId) async {
    try {
      isLoading.value = true;
      final fetchedBooking = await _bookingService.getBookingById(bookingId);
      if (fetchedBooking != null) {
        booking.value = fetchedBooking;
        return fetchedBooking;
      }
      Get.snackbar(
        "Error",
        "Booking not found.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch booking.",
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error fetching booking by ID: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBooking(BookingRequest request) async {
    try {
      isLoading.value = true;
      return await _bookingService.createBooking(request);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create booking.",
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error creating booking: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      isLoading.value = true;
      final success = await _bookingService.cancelBooking(bookingId.toString());
      if (success) {
        await refreshBookings();
        Get.snackbar(
          "Success",
          "Booking cancelled successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to cancel booking.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while cancelling booking.",
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error cancelling booking: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBookings() async {
    bookings.clear();
    await fetchBookings();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
  }
}