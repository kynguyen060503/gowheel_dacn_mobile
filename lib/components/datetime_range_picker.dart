import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'snackbar.dart';

class DateTimeRangePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(DateTime?, DateTime?, TimeOfDay?, TimeOfDay?) onDateTimeRangeSelected;
  final int numberOfDays;
  final List<DateTimeRange> blackoutDateRanges;

  const DateTimeRangePickerWidget({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.onDateTimeRangeSelected,
    required this.numberOfDays,
    this.blackoutDateRanges = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Rental Time",
              style: GoogleFonts.urbanist(
                color: const Color(0xFF213A58),
                fontSize: 20,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _showDatePicker(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Start: ',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatDateTime(startDate, startTime),
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'End: ',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatDateTime(endDate, endTime),
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (numberOfDays > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Rental Period: $numberOfDays days',
                  style: GoogleFonts.urbanist(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
  // Show the date picker dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  minDate: DateTime.now(),
                  maxDate: DateTime.now().add(const Duration(days: 365)),
                  initialSelectedRange: startDate != null && endDate != null
                      ? PickerDateRange(startDate!, endDate!)
                      : null,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    blackoutDates: _getBlockedDates(),
                  ),
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                    if (args.value is PickerDateRange) {
                      final range = args.value as PickerDateRange;
                      if (range.startDate != null && range.endDate != null) {
                        if (_isRangeBlocked(range.startDate!, range.endDate!)) {
                          Snackbar.showError("Error", "Date are already selected by other user!");
                          return;
                        }
                        await Future.delayed(const Duration(seconds: 1));
                        final TimeOfDay? pickedStartTime = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );

                        if (pickedStartTime != null) {
                          // Show time picker for end time
                          final TimeOfDay? pickedEndTime = await showTimePicker(
                            context: context,
                            initialTime: endTime ?? TimeOfDay.now(),
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );

                          if (pickedEndTime != null) {
                            onDateTimeRangeSelected(
                              range.startDate,
                              range.endDate,
                              pickedStartTime,
                              pickedEndTime,
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  List<DateTime> _getBlockedDates() {
    // Convert API response to blocked dates
    List<DateTime> blockedFullRange = [];

    for (DateTimeRange range in blackoutDateRanges) {
      // Add all dates between start and end (inclusive)
      for (DateTime date = range.start; date.isBefore(range.end.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
        blockedFullRange.add(date);
      }
    }

    return blockedFullRange;
  }

  bool _isRangeBlocked(DateTime start, DateTime end) {
    final blockedDates = _getBlockedDates();

    // Check if any date in the selected range is blocked
    for (DateTime date = start; date.isBefore(end.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      if (blockedDates.any((blockedDate) => blockedDate.year == date.year && blockedDate.month == date.month && blockedDate.day == date.day)) {
        return true;
      }
    }

    return false;
  }

  bool _isDateBlocked(DateTime date) {
    final blockedDates = _getBlockedDates();

    // Check if the specific date is blocked
    return blockedDates.any((blockedDate) => blockedDate.year == date.year && blockedDate.month == date.month && blockedDate.day == date.day);
  }

  String _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return '';
    final dateStr = DateFormat('dd/MM/yyyy').format(date);
    final timeStr = time != null ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}' : '--:--';
    return '$dateStr $timeStr';
  }
}
