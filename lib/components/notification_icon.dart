import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationController _controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return badges.Badge(
        position: badges.BadgePosition.topEnd(top: -10, end: -10),
        showBadge: _controller.unreadCount.value > 0,
        badgeContent: Text(
          '${_controller.unreadCount.value}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        child: Icon(Icons.notifications),
      );
    });
  }
}