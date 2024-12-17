import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();
  
  RxList<Notification> notifications = <Notification>[].obs;
  RxBool isLoading = false.obs;
  final RxInt unreadCount = 0.obs;
  late final RxInt notificationCount;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _service.getAllNotifications();
      _updateUnreadCount(); // Update unread count after fetching
    } catch (e) {
      print('Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // New method to update unread count
  void _updateUnreadCount() {
    unreadCount.value = notifications
        .where((notification) => notification.isRead == false)
        .length;
  }

  Future<void> markNotificationRead(int notificationId) async {
    await _service.markNotificationAsRead(notificationId);
    await fetchNotifications(); // Refresh the list and update counts
  }

  void clearCount() {
    unreadCount.value = 0;
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}