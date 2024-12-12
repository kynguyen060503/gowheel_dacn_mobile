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
    } catch (e) {
      print('Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markNotificationRead(int notificationId) async {
    await _service.markNotificationAsRead(notificationId);
    // Optionally refresh the list or update the specific notification
    fetchNotifications();
  }

  void incrementCount() {
    unreadCount.value++;
  }
  
  void clearCount() {
    unreadCount.value = 0;
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}
