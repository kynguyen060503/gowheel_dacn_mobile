import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimeRangePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(DateTime?, DateTime?, TimeOfDay?, TimeOfDay?) onDateTimeRangeSelected;
  final int numberOfDays;

  const DateTimeRangePickerWidget({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.onDateTimeRangeSelected,
    required this.numberOfDays,
  }) : super(key: key);

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      currentDate: DateTime.now(),
      saveText: 'SELECT',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // After selecting the start date, show the start time picker
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
        // After selecting the start time, show the end time picker
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
              picked.start,
              picked.end,
              pickedStartTime,
              pickedEndTime
          );
        }
      }
    }
  }

  String _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return '';
    final dateStr = DateFormat('dd/MM/yyyy').format(date);
    final timeStr = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : '--:--';
    return '$dateStr $timeStr';
  }

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
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: EdgeInsets.all(12),
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
}
