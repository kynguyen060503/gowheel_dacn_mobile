import 'dart:convert';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:http/http.dart' as http;

import '../models/notification_model.dart';
import '../url.dart';

class NotificationService {
  TokenService tokenService = TokenService();

  Future<List<Notification>> getAllNotifications() async {
    try {
      final token = await tokenService.getToken();
      
      final response = await http.get(
        Uri.parse('${URL.baseUrl}Notifiy/GetAllNotify'),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> notificationsJson = jsonResponse['data'];
        
        return notificationsJson
            .map((json) => Notification.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final token = await tokenService.getToken();
      
      final response = await http.put(
        Uri.parse('${URL.baseUrl}Notifiy/MarkAsRead/$notificationId'),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}