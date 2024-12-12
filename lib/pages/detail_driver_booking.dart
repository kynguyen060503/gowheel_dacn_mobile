import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/driver_booking_model.dart';
import '../controllers/driver_booking_controller.dart';

class DriverBookingDetail extends StatelessWidget {
  final DriverBooking booking;

  const DriverBookingDetail({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Booking #${booking.id} Details',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF213A58)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Status Card
              _buildBookingStatusCard(),

              // Customer Information Section
              _buildSectionTitle('Customer Information'),
              _buildCustomerInfoCard(),

              // Vehicle Information Section
              _buildSectionTitle('Vehicle Details'),
              _buildVehicleInfoCard(),

              // Booking Details Section
              _buildSectionTitle('Booking Details'),
              _buildBookingDetailsCard(),

              // Pricing Section
              _buildSectionTitle('Pricing'),
              _buildPricingCard(),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingStatusCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusCardColor(),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            booking.status.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Name', booking.user.name),
        _buildInfoRow('Contact', booking.user.phoneNumber?? 'N/A'),
      ],
    );
  }

  Widget _buildVehicleInfoCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Vehicle', booking.post.name),
        _buildInfoRow('Model', booking.post.carTypeName ?? 'N/A'),
        _buildInfoRow('Company', booking.post.companyName ?? 'N/A'),
      ],
    );
  }

  Widget _buildBookingDetailsCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Pickup Date', _formatDateTime(booking.recieveOn)),
        _buildInfoRow('Return Date', _formatDateTime(booking.returnOn)),
        _buildInfoRow('Rental Duration', _calculateRentalDuration()),
        _buildInfoRow('Driver Required', booking.isRequireDriver ? 'Yes' : 'No'),
      ],
    );
  }

  Widget _buildPricingCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Base Price', '\$${booking.total.toStringAsFixed(2)}'),
        if (booking.promotion != null)
          _buildInfoRow(
            'Promotion', 
            '${booking.promotion!.content} (${(booking.promotion!.discountValue * 100).toStringAsFixed(0)}% off)'
          ),
        _buildInfoRow('Pre-Payment', '${booking.prePayment.toStringAsFixed(0)} VND'),
        _buildInfoRow('Final Value', '${booking.finalValue.toStringAsFixed(0)} VND'),
        _buildInfoRow('Payment Status', booking.isPay ? 'Paid' : 'Pending'),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            text: 'Accept Booking',
            color: Colors.green,
            onPressed: _handleAcceptBooking,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF213A58),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text, 
    required Color color, 
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Utility Methods
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String _calculateRentalDuration() {
    Duration duration = booking.returnOn.difference(booking.recieveOn);
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    return '$days days, $hours hours';
  }

  Color _getStatusCardColor() {
    switch (booking.status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _handleAcceptBooking() async {
    final controller = Get.find<DriverBookingController>();
    await controller.acceptBooking(booking.id);
    Get.back();
  }
}