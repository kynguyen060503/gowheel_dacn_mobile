import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/location_controler.dart';

class LocationTrackingPage extends StatefulWidget {
  @override
  _LocationTrackingPageState createState() => _LocationTrackingPageState();
}

class _LocationTrackingPageState extends State<LocationTrackingPage> {
  final LocationController _locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    // Automatically update location when page loads
    _locationController.updateCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracking'),
      ),
      body: Center(
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _locationController.isLoading.value
              ? CircularProgressIndicator()
              : ElevatedButton.icon(
                  onPressed: _locationController.updateCurrentLocation,
                  icon: Icon(Icons.location_on),
                  label: Text('Update Location'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
          ],
        )),
      ),
    );
  }
}