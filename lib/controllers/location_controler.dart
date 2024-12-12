import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../components/snackbar.dart';
import '../service/location_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  final isLoading = false.obs;
  final RxString currentAddress = ''.obs;

  // Get current location
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Snackbar.showError("Error", "Location services are disabled");
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Snackbar.showError("Error", "Location permissions are denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Snackbar.showError("Error", "Location permissions are permanently denied");
      return null;
    }

    // Get current location
    return await Geolocator.getCurrentPosition();
  }

  // Update current location and retrieve address
  Future<void> updateCurrentLocation() async {
    isLoading.value = true;
    try {
      final position = await getCurrentLocation();

      if (position != null) {
        // Update address
        await _getAddressFromCoordinates(position);

        // Update location on server
        print("Current Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        final response = await _locationService.updateDriverLocation(
          '${position.latitude}', 
          '${position.longitude}'
        );

        if (response != null && response.success) {
          Snackbar.showSuccess("Success", "Location updated successfully!");
        } else {
          Snackbar.showError("Error", response?.message ?? "Location update failed!");
        }
      } else {
        Snackbar.showError("Error", "Unable to get current location");
      }
    } catch (e) {
      Snackbar.showWarning('Error', 'Error while updating location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get readable address from coordinates
  Future<void> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentAddress.value = _formatAddress(place);
      } else {
        currentAddress.value = 'Address not found';
      }
    } catch (e) {
      print('Error getting address: $e');
      currentAddress.value = 'Unable to retrieve address';
    }
  }

  // Format address in a readable way
  String _formatAddress(Placemark place) {
    return '${place.street}, ${place.subLocality}, '
           '${place.locality}, ${place.administrativeArea} '
           '${place.postalCode}, ${place.country}';
  }
}