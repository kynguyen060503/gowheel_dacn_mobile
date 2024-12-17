import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/booking_controller.dart';
import '../url.dart';

class OwnerPendingBookingScreen extends StatelessWidget {
  final BookingController controller = Get.put(BookingController()); // Initialize once
  
  OwnerPendingBookingScreen({super.key}){
    Get.put(BookingController()).fetchPendingBookingsByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Pending Bookings',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetX<BookingController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchPendingBookingsByUserId();
            },
            child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.bookings.isEmpty
                ? Center(
                    child: Text(
                      'No pending bookings',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.bookings.length,
                      itemBuilder: (context, index) {
                        final booking = controller.bookings[index];
                        return PendingBookingCard(booking: booking);
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class PendingBookingCard extends StatelessWidget {
  final dynamic booking;

  const PendingBookingCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    URL.imageUrl + booking.post.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${booking.post.name} #${booking.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoText('Renter', booking.user.name),
                      _buildInfoText(
                        'Pick-up',
                        DateFormat('dd/MM/yyyy HH:mm').format(booking.recieveOn),
                      ),
                      _buildInfoText(
                        'Return',
                        DateFormat('dd/MM/yyyy HH:mm').format(booking.returnOn),
                      ),
                      _buildInfoText(
                        'Total',
                        NumberFormat.currency(locale: 'vi').format(booking.total),
                      ),
                      _buildInfoText(
                        'Driver',
                        booking.isRequireDriver ? 'Required' : 'Self-drive',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement deny booking
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Deny'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement accept booking
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}