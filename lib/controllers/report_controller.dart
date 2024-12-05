// report_controller.dart
import 'package:get/get.dart';

import '../components/snackbar.dart';
import '../models/report_model.dart';
import '../service/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<Report> report = <Report>[].obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllReportType();
  }

  Future<void> getAllReportType() async {
    try {
      isLoading.value = true;
      error.value = '';
      final reportTypeList = await _reportService.getAllReportType();

      if (reportTypeList.isEmpty) {
        error.value = 'No report types found';
      } else {
        report.assignAll(reportTypeList);
      }

    } catch (e) {
      error.value = 'Failed to load report types: $e';
      Snackbar.showError(
        "Error",
        'Failed to load report types: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createReport({
    required String content,
    required int postId,
    required int reportTypeId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await _reportService.createReport(
        content: content,
        postId: postId,
        reportTypeId: reportTypeId,
      );

      if (!success) {
        error.value = 'Failed to create report';
        Snackbar.showError(
          "Error",
          'Failed to create report',
        );
      }

      return success;
    } catch (e) {
      print('Error in createReport controller: $e');
      error.value = 'Failed to create report: $e';
      Snackbar.showError(
        "Error",
        'Failed to create report: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}