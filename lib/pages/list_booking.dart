import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/booking_controller.dart';
import '../controllers/payment_controller.dart';
import '../service/momo_payment_service.dart';
import '../url.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Your Booking',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetX<BookingController>(
        init: BookingController(),
        builder: (controller) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        selected: controller.selectedStatus.value == '',
                        onSelected: () => controller.setStatusFilter(''),
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Pending',
                        selected: controller.selectedStatus.value == 'Pending',
                        onSelected: () => controller.setStatusFilter('Pending'),
                        color: Colors.orange,
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Owner Confirm',
                        selected: controller.selectedStatus.value == 'Accept Booking',
                        onSelected: () => controller.setStatusFilter('Accept Booking'),
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Canceled Processing',
                        selected: controller.selectedStatus.value == 'Processing',
                        onSelected: () => controller.setStatusFilter('Processing'),
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Canceled',
                        selected: controller.selectedStatus.value == 'Canceled',
                        onSelected: () => controller.setStatusFilter('Canceled'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshBookings();
                  },
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Skeletonizer(
                          enabled: controller.isLoading.value,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = controller.filteredBookings[index];
                              return BookingCard(
                                booking: booking,
                                isLoading: controller.isLoading.value,
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    required Color color,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.grey[200],
      selectedColor: color,
      checkmarkColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class BookingCard extends StatefulWidget {
  final dynamic booking;
  final bool isLoading;

  const BookingCard({
    super.key, 
    required this.booking, 
    required this.isLoading
  });

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isExpanded = false;
  String _locationAddress = 'Working in progress...';

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

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, 
        longitude
      );

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
      print('Error while determine address: $e');
    }
  }

  Future<void> _handlePayment(int invoiceId) async {
    try {
      final paymentController = PaymentController(MomoPaymentService());
      await paymentController.processPayment(invoiceId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Góc bo tròn
        side: BorderSide(
          color: Colors.grey, // Màu viền
          width: 3,          // Độ dày viền
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.isLoading
                          ? Container(
                              width: 100, 
                              height: 100, 
                              color: Colors.grey[300]
                            )
                          : Image.network(
                              URL.imageUrl + widget.booking.post.image,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booking.post.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pick-up date: ${DateFormat('dd/MM/yyyy').format(widget.booking.recieveOn)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Return date:\n${DateFormat('dd/MM/yyyy').format(widget.booking.returnOn)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Rental price: ${NumberFormat.currency(locale: 'vi').format(widget.booking.total)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Expanded details section
                _buildExpandedSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSection() {
    return Column(
      children: [
        if (_isExpanded) ..._buildExpandedContent(),
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isExpanded ? 'Thu gọn' : 'Xem chi tiết',
                  style: TextStyle(color: Colors.blue),
                ),
                Icon(
                  _isExpanded 
                    ? Icons.keyboard_arrow_up 
                    : Icons.keyboard_arrow_down,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildExpandedContent() {
    return [
      Divider(height: 24),
      _buildInfoRow('Trạng thái đơn', _buildStatusChip(widget.booking.status)),
      _buildInfoRow('Yêu cầu tài xế', _buildDriverRequestChip(widget.booking.isRequireDriver)),
      _buildInfoRow('Thời gian nhận:', DateFormat('dd/MM/yyyy HH:mm').format(widget.booking.recieveOn)),
      _buildInfoRow('Thời gian trả:', DateFormat('dd/MM/yyyy HH:mm').format(widget.booking.returnOn)),
      _buildInfoRow('Tổng tiền:', '${NumberFormat.currency(locale: 'vi').format(widget.booking.total)}'),
      if (widget.booking.latitude != null && widget.booking.longitude != null)
        _buildInfoRow('Địa điểm thuê:', _locationAddress),
      if (widget.booking.promotion != null && widget.booking.promotion!.content.isNotEmpty)
        _buildInfoRow('Khuyến mãi:', widget.booking.promotion!.content),
      _buildInfoRow('Số tiền cuối:', '${NumberFormat.currency(locale: 'vi').format(widget.booking.finalValue)}'),
      _buildInfoRow('Tiền cọc:', '${NumberFormat.currency(locale: 'vi').format(widget.booking.prePayment)}'),
      
      if(widget.booking.status == 'Pending' || widget.booking.status == 'Accept Booking')
      SizedBox(height: 16),
      if(widget.booking.status == 'Pending' || widget.booking.status == 'Accept Booking')
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _showCancelDialog(context, widget.booking.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Hủy đặt xe'),
          ),
          ElevatedButton(
              onPressed: () => _handlePayment(widget.booking.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Thanh toán'),
          ),
        ],
      ),
    ];
  }

    void _showCancelDialog(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancellation confirmation'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('NO'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.find<BookingController>().cancelBooking(bookingId);
                Navigator.pop(context);
                Get.find<BookingController>().refreshBookings();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }



  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: value is String
              ? Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              : value,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'accept booking':
        chipColor = Colors.green;
        break;
      case 'processing':
        chipColor = Colors.cyan;
        break;
      case 'waiting':
        chipColor = Colors.green;
        break;
      case 'denied':
        chipColor = Colors.red;
        break;
      case 'canceled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildDriverRequestChip(bool status) {
    Color chipColor;
    String message = '';
    switch (status) {
      case true:
        message = "Driver required";
        chipColor = Colors.orange;
        break;
      case false:
        message = 'Self drive';
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }
}