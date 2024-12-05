import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/invoice_controller.dart';
import '../controllers/payment_controller.dart';
import '../models/invoice_model.dart';
import '../service/momo_payment_service.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Your Invoices',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetX<InvoiceController>(
        init: InvoiceController(),
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
                        label: 'Paid',
                        selected: controller.selectedStatus.value == 'true',
                        onSelected: () => controller.setStatusFilter('true'),
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Unpaid',
                        selected: controller.selectedStatus.value == 'false',
                        onSelected: () => controller.setStatusFilter('false'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshInvoices();
                  },
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Skeletonizer(
                          enabled: controller.isLoading.value,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.filteredInvoices.length,
                            itemBuilder: (context, index) {
                              final invoice = controller.filteredInvoices[index];
                              return InvoiceCard(
                                invoice: invoice,
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

class InvoiceCard extends StatefulWidget {
  final Invoice invoice; // Change to use the specific Invoice type
  final bool isLoading;

  const InvoiceCard({
    super.key, 
    required this.invoice, 
    required this.isLoading
  });

  @override
  _InvoiceCardState createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey,
          width: 3,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invoice #${widget.invoice.id}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildPaymentChip(widget.invoice.isPay),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice Date: ${DateFormat('dd/MM/yyyy').format(widget.invoice.createdOn)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total Amount: ${NumberFormat.currency(locale: 'vi').format(widget.invoice.total)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                if (widget.invoice.booking != null) _buildExpandedSection(),
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
    final booking = widget.invoice.booking!;
    return [
      Divider(height: 24),
      _buildInfoRow('Booking Status:', booking.status),
      _buildInfoRow('Driver Required:', booking.isRequireDriver ? 'Yes' : 'No'),
      _buildInfoRow('Driver Assigned:', booking.hasDriver ? 'Yes' : 'No'),
      _buildInfoRow('Receive Date:', DateFormat('dd/MM/yyyy HH:mm').format(booking.recieveOn)),
      _buildInfoRow('Return Date:', DateFormat('dd/MM/yyyy HH:mm').format(booking.returnOn)),
      _buildInfoRow('Pre-payment:', NumberFormat.currency(locale: 'vi').format(widget.invoice.prePayment)),
      _buildInfoRow('Total Amount:', NumberFormat.currency(locale: 'vi').format(widget.invoice.total)),
      
      if (booking.user != null) ...[
        Divider(height: 24),
        _buildInfoRow('Customer Name:', booking.user!.name),
        if (booking.user!.phoneNumber != null)
          _buildInfoRow('Phone Number:', booking.user!.phoneNumber!),
      ],

      SizedBox(height: 16),
      if (!widget.invoice.isPay)
        PaymentButton(invoiceId: widget.invoice.booking!.id),
    ];
  }

  Widget _buildInfoRow(String label, String value) {
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
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentChip(bool isPay) {
    return Chip(
      label: Text(
        isPay ? 'Paid' : 'Unpaid',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isPay ? Colors.green : Colors.red,
    );
  }
}

class PaymentButton extends StatelessWidget {
  final int invoiceId;

  const PaymentButton({
    Key? key,
    required this.invoiceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize with MomoPaymentService
    final controller = Get.put(PaymentController(MomoPaymentService()));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => ElevatedButton(
        onPressed: controller.isProcessing.value
            ? null
            : () => controller.processPayment(invoiceId),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF80EE98),
          foregroundColor: const Color(0xFF213A58),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          disabledBackgroundColor: const Color(0xFF80EE98).withOpacity(0.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isProcessing.value) ...[
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFF213A58),
                  strokeWidth: 2.5,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              controller.isProcessing.value ? 'Processing Payment...' : 'Pay with MoMo',
              style: GoogleFonts.lexendDeca(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!controller.isProcessing.value) ...[
              const SizedBox(width: 8),
              const Icon(Icons.payment, size: 20),
            ],
          ],
        ),
      )),
    );
  }
}