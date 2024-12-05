import 'dart:convert';

import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/promotion_model.dart';

class UserPromotionService {
  static final UserPromotionService _instance = UserPromotionService._internal();
  factory UserPromotionService() => _instance;
  UserPromotionService._internal();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<bool> addPromotion({
    required String content,
    required double discountValue,
    required DateTime expiredDate,
    required List<int> postIds,
  }) async {
    try {
      final token = await getToken();
      var uri = Uri.parse('${URL.baseUrl}UserPromotion/Add');

      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'accept': 'text/plain',
      });

      request.fields.addAll({
        'Content': content,
        'DiscountValue': discountValue.toString(),
        'ExpiredDate': expiredDate.toIso8601String(),
      });

      for (var postId in postIds) {
        request.fields['PostIds'] = postId.toString();
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(responseData);
        return decodedResponse['success'] ?? false;
      } else {
        throw Exception('Failed to add promotion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add promotion: $e');
    }
  }

  Future<List<Promotion>> getAllUserPromotions() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${URL.baseUrl}UserPromotion/GetAllByUserId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is List) {
          return responseData
              .map((json) => Promotion.fromJson(json))
              .toList();
        } else if (responseData is Map) {
          // Nếu là map, thử lấy danh sách từ một key cụ thể
          final List? promotionList = responseData['promotions'] ?? responseData['data'];
          if (promotionList is List) {
            return promotionList
                .map((json) => Promotion.fromJson(json))
                .toList();
          }
        }

        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to load user promotions: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> deletePromotion(int promotionId) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('${URL.baseUrl}UserPromotion/Delete/$promotionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] ?? true;
      } else {
        throw Exception('Failed to delete promotion: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}