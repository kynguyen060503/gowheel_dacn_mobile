import 'dart:convert';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../models/comment_model.dart';
import '../url.dart';

class CommentService extends GetxService {
  static final CommentService _instance = CommentService._internal();
  factory CommentService() => _instance;
  CommentService._internal();

  final TokenService  tokenService = TokenService();

  Future<bool> addComment(int postId, String content, int point) async {
    final token = await tokenService.getToken();
    try {
      final response = await http.post(
        Uri.parse("${URL.baseUrl}User/RatingAndComment/Add"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'comment': content,
          'point': point,
          'postId': postId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Comment>> getComments(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('${URL.baseUrl}User/RatingAndComment/GetCommentByPostId/$postId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] && jsonResponse['data'] != null) {
          final List<dynamic> commentsList = jsonResponse['data'];

          final comments = commentsList.map((json) => Comment.fromJson(json)).toList();
          return comments;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  Future<bool> removeComment(int id) async {
    try {
      final token = await tokenService.getToken();
      final response = await http.delete(
        Uri.parse('${URL.baseUrl}User/RatingAndComment/Delete/$id'),
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