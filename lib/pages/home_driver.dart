import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/pages/detail_driver_booking.dart';
import '../controllers/location_controler.dart';
import '../controllers/driver_booking_controller.dart';
import '../models/driver_booking_model.dart';
import '../components/notification_icon.dart';

class HomeDriverPage extends StatefulWidget {
  const HomeDriverPage({Key? key}) : super(key: key);

  @override
  _HomeDriverPageState createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> with WidgetsBindingObserver {
  final LocationController _locationController = Get.put(LocationController());
  final DriverBookingController _bookingController = Get.put(DriverBookingController());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLocationAndFetchBookings();
    });
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateLocationAndFetchBookings();
    }
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _updateLocationAndFetchBookings();
    });
  }

  Future<void> _updateLocationAndFetchBookings() async {
    try {
      final position = await _locationController.getCurrentLocation();
      if (position != null) {
        await _locationController.updateCurrentLocation();
        await _bookingController.fetchBookingsInRange(
          position.longitude,
          position.latitude
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update data');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        title: Text(
          'Driver Home',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: NotificationIcon(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _updateLocationAndFetchBookings,
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Location Section
                _buildCurrentLocationSection(size),
                
                // Bookings Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Available Bookings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                // Loading or Bookings List
                _locationController.isLoading.value && _bookingController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : _buildBookingsList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentLocationSection(Size size) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _locationController.isLoading.value ? null : _updateLocationAndFetchBookings,
                icon: Icon(Icons.location_on),
                label: Text('Update'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(() {
            return Text(
              _locationController.currentAddress.value.isNotEmpty
                  ? _locationController.currentAddress.value
                  : 'Location not available',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    if (_bookingController.bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No bookings available in your area',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _bookingController.bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookingController.bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(DriverBooking booking) {
    return GestureDetector(
      onTap: () => Get.to(() => DriverBookingDetail(booking: booking)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #${booking.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: Color(0xFF213A58)
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Available nearby",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildBookingDetailRow('Customer', booking.user.name),
              _buildBookingDetailRow('Vehicle', booking.post.name),
              _buildBookingDetailRow('Total', '\$${booking.total.toStringAsFixed(2)}'),
              _buildBookingDetailRow('From', _formatDateTime(booking.recieveOn)),
              _buildBookingDetailRow('To', _formatDateTime(booking.returnOn)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}