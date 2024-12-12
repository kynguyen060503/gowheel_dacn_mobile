import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends StatelessWidget {
  final NotificationController _controller = Get.put(NotificationController());

  NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        title: Text(
          'Your Notification',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh:  () async {
          await _controller.fetchNotifications();
        },
          child: _controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : _controller.notifications.isEmpty
                  ? const Center(child: Text('No notifications'))
                  : ListView.builder(
                      itemCount: _controller.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _controller.notifications[index];
                        return ListTile(
                          title: Text(notification.content ?? 'No Content'),
                          subtitle: Text(
                            notification.createOn != null
                                ? DateTime.parse(notification.createOn!).toLocal().toString()
                                : 'No Date',
                          ),
                          trailing: notification.isRead == false
                              ? const Icon(Icons.circle, color: Colors.blue, size: 10)
                              : null,
                          onTap: () {
                            // Đánh dấu thông báo là đã đọc khi nhấn vào
                            _controller.markNotificationRead(notification.id!);
                          },
                        );
                      },
                    ),
        );
      }),
    );
  }
}
