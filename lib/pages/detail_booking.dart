import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/pages/detail_post.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import '../models/booking_model.dart';
import '../url.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  String _locationAddress = 'Determining location...';

  @override
  void initState() {
    super.initState();
    if (widget.booking.latitude != null && widget.booking.longitude != null) {
      _getAddressFromCoordinates();
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      double latitude = double.parse(widget.booking.latitude!);
      double longitude = double.parse(widget.booking.longitude!);

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _locationAddress = 
            '${place.street ?? ''}, '
            '${place.subAdministrativeArea ?? ''}, '
            '${place.administrativeArea ?? ''}, '
            '${place.country ?? ''}';
        });
      }
    } catch (e) {
      setState(() {
        _locationAddress = 'Unable to determine address';
      });
      print('Error while determining address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Booking #${widget.booking.id}',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF213A58)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingStatusCard(),
              _buildSectionTitle('Booking Details'),
              _buildBookingDetailsCard(),
              _buildSectionTitle('Price Details'),
              _buildPricingCard(),
              _buildSectionTitle('Location'),
              _buildLocationCard(),
              _buildSectionTitle('Vehicle Details'),
              _buildVehicleDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingStatusCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.booking.status),
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
            widget.booking.status.toUpperCase(),
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

  Widget _buildBookingDetailsCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Booking Created', DateFormat('dd/MM/yyyy HH:mm').format(widget.booking.createdOn)),
        _buildInfoRow('Pick-up Date', DateFormat('dd/MM/yyyy HH:mm').format(widget.booking.recieveOn)),
        _buildInfoRow('Return Date', DateFormat('dd/MM/yyyy HH:mm').format(widget.booking.returnOn)),
        _buildInfoRow('Driver Required', widget.booking.isRequireDriver ? 'Yes' : 'No'),
      ],
    );
  }

  Widget _buildPricingCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Total Price', NumberFormat.currency(locale: 'vi').format(widget.booking.total)),
        _buildInfoRow('Pre-payment', NumberFormat.currency(locale: 'vi').format(widget.booking.prePayment)),
        _buildInfoRow('Final Value', NumberFormat.currency(locale: 'vi').format(widget.booking.finalValue)),
        if (widget.booking.promotion != null)
          _buildInfoRow('Promotion', '${widget.booking.promotion!.content} (${widget.booking.promotion!.discountValue * 100}% off)'),
      ],
    );
  }

  Widget _buildLocationCard() {
    return _buildInfoCard(
      children: [
        _buildInfoRow('Pickup Location', _locationAddress, allowWrap: true),
      ],
    );
  }

  Widget _buildVehicleDetailsCard() {
    return GestureDetector(
      onTap: () => Get.to(DetailPage(post: widget.booking.post)),
      child: _buildInfoCard(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              URL.imageUrl + widget.booking.post.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Vehicle Name', widget.booking.post.name),
          _buildInfoRow('Vehicle Owner', widget.booking.post.user?.name ?? 'N/A'),
          if (widget.booking.post.carTypeName != null)
            _buildInfoRow('Vehicle Type', widget.booking.post.carTypeName!),
          if (widget.booking.post.companyName != null)
            _buildInfoRow('Company', widget.booking.post.companyName!),
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

  Widget _buildInfoRow(String label, String value, {bool allowWrap = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: allowWrap 
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                softWrap: true,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accept booking':
      case 'waiting':
        return Colors.green;
      case 'processing':
        return Colors.cyan;
      case 'denied':
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}