import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../models/booking_request_model.dart';
import '../service/booking_service.dart';

class BookingController extends GetxController {
  final BookingService _bookingService = BookingService();
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxBool isLoading = false.obs;
  final selectedStatus = ''.obs;

  List<dynamic> get filteredBookings {
    if (selectedStatus.value.isEmpty) {
      return bookings;
    }
    return bookings.where((booking) => 
      booking.status.toLowerCase() == selectedStatus.value.toLowerCase()
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading.value = true;
    try {
      final response = await _bookingService.getBookings();
      if (response != null && response.success) {
        bookings.assignAll(response.data);
      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> createBooking(BookingRequest request) async {
    isLoading.value = true;
    try {
      print(request);
      final result = await _bookingService.createBooking(request);
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    isLoading.value = true;
    final success = await _bookingService.cancelBooking(bookingId.toString());
    if (success) {
      await refreshBookings();
      Get.snackbar("Success", "Booking cancelled successfully!");
    } else {
      Get.snackbar("Error", "Failed to cancel booking.");
    }
    isLoading.value = false;
  }

  Future<void> refreshBookings() async {
    bookings.clear();
    await fetchBookings();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
  }
}