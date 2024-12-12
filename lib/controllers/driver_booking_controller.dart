import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/driver_booking_model.dart';
import '../service/driver_booking_service.dart';
import '../components/snackbar.dart';
import 'location_controler.dart';

class DriverBookingController extends GetxController {
  final DriverBookingService _bookingService = DriverBookingService();
  final LocationController _locationController = Get.find<LocationController>();
  final RxList<DriverBooking> bookings = <DriverBooking>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isAccepting = false.obs;

  Future<void> fetchBookingsInRange(double longitude, double latitude) async {
    isLoading.value = true;
    try {
      // Get current location using LocationController
      final Position? position = await _locationController.getCurrentLocation();
      
      if (position != null) {
        final result = await _bookingService.getBookingsInRange(
          position.longitude,
          position.latitude,
        );
        
        if (result != null) {
          bookings.assignAll(result);
        } else {
          Snackbar.showWarning(
            "Warning",
            "No bookings found in your area"
          );
        }
      } else {
        Snackbar.showError(
          "Error",
          "Unable to get location. Please check your location settings."
        );
      }
    } catch (e) {
      Snackbar.showError(
        "Error",
        "Failed to fetch bookings: ${e.toString()}"
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> acceptBooking(int bookingId) async {
    isAccepting.value = true;
    try {
      final success = await _bookingService.acceptBooking(bookingId);
      if (success) {
        // Get current location and fetch updated bookings
        final position = await _locationController.getCurrentLocation();
        if (position != null) {
          // Fetch bookings with current location after successful acceptance
          await fetchBookingsInRange(
            position.longitude,
            position.latitude
          );
        }
        return true;
      }
      return false;
    } finally {
      isAccepting.value = false;
    }
  }
}