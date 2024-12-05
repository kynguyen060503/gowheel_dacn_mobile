import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import '../controllers/report_controller.dart';
import '../models/report_model.dart';

class ReportBottomSheet extends StatefulWidget {
  final int postId;

  const ReportBottomSheet({Key? key, required this.postId}) : super(key: key);

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  final ReportController _reportController = Get.put(ReportController());
  final TextEditingController _contentController = TextEditingController();
  Report? selectedReportType;

  @override
  void initState() {
    super.initState();
    _reportController.getAllReportType();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'Báo cáo vi phạm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            Obx(() {
              if (_reportController.isLoading.value) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (_reportController.report.isEmpty) {
                return Center(
                  child: Text('Không có loại vi phạm nào'),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<Report>(
                  decoration: InputDecoration(
                    labelText: 'Loại vi phạm',
                      border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.type_specimen_outlined),
                  ),
                  value: selectedReportType,
                  hint: Text('Chọn loại vi phạm'),
                  items: _reportController.report.map((report) {
                    return DropdownMenuItem<Report>(
                      value: report,
                      child: Text(report.name ?? ''),
                    );
                  }).toList(),
                  onChanged: (Report? value) {
                    setState(() {
                      selectedReportType = value;
                    });
                  },
                ),
              );
            }),

            SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Nội dung báo cáo',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 3,
              ),
            ),

            SizedBox(height: 24),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black,
                ),
                onPressed: _reportController.isLoading.value
                    ? null
                    : () async {
                  if (selectedReportType == null) {
                    Snackbar.showError("Error", "Please choose report type!");
                    return;
                  }

                  if (_contentController.text.isEmpty) {
                    Snackbar.showError("Error", "Please type report content!");
                    return;
                  }

                  final success = await _reportController.createReport(
                    content: _contentController.text,
                    postId: widget.postId,
                    reportTypeId: selectedReportType!.id!,
                  );

                  if (success) {
                    Navigator.pop(context);
                    Snackbar.showSuccess("Success", "Report sent!");
                  }
                },
                child: _reportController.isLoading.value
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}