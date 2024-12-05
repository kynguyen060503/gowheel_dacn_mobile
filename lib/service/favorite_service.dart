import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../url.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  TokenService tokenService = TokenService();

  Future<Map<int, int>> getFavorites() async {
    try {
      final token = await tokenService.getToken();
      final response = await http.get(
        Uri.parse('${URL.baseUrl}User/Favorite/GetAllFavorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> favorites = jsonResponse['data'];

          return Map.fromEntries(
            favorites.map((item) => MapEntry(
              item['post']['id'] as int,
              item['id'] as int,
            )),
          );
        }
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<bool> addToFavorite(int postId) async {
    try {
      final token = await tokenService.getToken();
      final response = await http.post(
        Uri.parse('${URL.baseUrl}User/Favorite/AddToFavorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'postId': postId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromFavorite(int id) async {
    try {
      final token = await tokenService.getToken();
      final response = await http.delete(
        Uri.parse('${URL.baseUrl}User/Favorite/RemoveFavorite/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}