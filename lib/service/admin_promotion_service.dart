import 'dart:convert';

import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import 'package:gowheel_flutterflow_ui/models/promotion_model.dart';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:http/http.dart' as http;

class AdminPromotionService {
  static final AdminPromotionService _instance = AdminPromotionService._internal();
  factory AdminPromotionService() => _instance;
  AdminPromotionService._internal();

  final TokenService tokenService = TokenService();

  Future<List<Promotion>?> getAllAdminPromotion() async {
    try {
    final token = await tokenService.getToken();

    final response = await http.get(
    Uri.parse('${URL.baseUrl}AdminPromotion/GetAllAdminPromotion'),
    headers: {
    'Authorization': 'Bearer $token',
    },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic>? postsJson = responseData['data'] as List<dynamic>?;
      final posts = postsJson?.map((json) {
        try {
          return Promotion.fromJson(json);
        } catch (e) {
          return null;
        }
      }).whereType<Promotion>().toList();

      return posts;
    } else {
      return [];
    }
    } catch (e) {
    Snackbar.showError('Error', 'Error fetching promotion');
    return null;
    }
  }
  
} 