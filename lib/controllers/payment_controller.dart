import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/momo_payment_service.dart';
import '../controllers/invoice_controller.dart';

class PaymentController extends GetxController {
  final MomoPaymentService _paymentService;
  final isProcessing = false.obs;

  PaymentController(this._paymentService);

  Future<void> processPayment(int invoiceId) async {
    try {
      isProcessing.value = true;
      await _paymentService.createAndLaunchMomoPayment(invoiceId);
      
      // Wait a bit before resetting processing state
      await Future.delayed(Duration(seconds: 1));
      isProcessing.value = false;
      
      // Optional: Refresh invoices after a successful launch
      Get.find<InvoiceController>().refreshInvoices();
      
    } catch (e) {
      isProcessing.value = false;
      Get.snackbar(
        'Error',
        'Failed to process payment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    }
  }
}