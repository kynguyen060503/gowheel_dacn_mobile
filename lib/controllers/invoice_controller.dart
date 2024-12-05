import 'package:get/get.dart';
import '../models/invoice_model.dart';
import '../service/invoice_service.dart';

class InvoiceController extends GetxController {
  final InvoiceService _invoiceService = InvoiceService();
  final RxList<Invoice> invoices = <Invoice>[].obs;
  final RxBool isLoading = false.obs;
  final selectedStatus = ''.obs;

  List<dynamic> get filteredInvoices {
    if (selectedStatus.value.isEmpty) {
      return invoices;
    }
    return invoices.where((invoice) => 
      invoice.isPay.toString() == selectedStatus.value
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    isLoading.value = true;
    try {
      invoices.assignAll(await _invoiceService.getInvoices());
    } catch (e) {
      Get.snackbar("Error", "Failed to load invoices");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshInvoices() async {
    invoices.clear();
    await fetchInvoices();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
  }
}