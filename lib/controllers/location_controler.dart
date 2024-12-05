import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../components/snackbar.dart';
import '../service/location_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  final isLoading = false.obs;

  // Lấy vị trí hiện tại
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí có bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition();
  }

  // Cập nhật vị trí lên server
  Future<void> updateCurrentLocation() async {
    isLoading.value = true;
    try {
      final position = await getCurrentLocation();

      if (position != null) {
        print("Current Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        final response = await _locationService.updateDriverLocation('${position.latitude}', '${position.longitude}');

        if (response != null && response.success) {
          Snackbar.showSuccess("Success", "Location updated successfully!");
        } else {
          Snackbar.showError("Error", response?.message ?? "Location update failed!");
        }
      } else {
        Snackbar.showError("Error", "Unable to get current location");
      }
    } catch (e) {
      Snackbar.showWarning('Error', 'Error while updating location!');
      
    } finally {
      isLoading.value = false;
    }
  }
}
