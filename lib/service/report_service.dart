import 'dart:convert';

import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/report_model.dart';

class ReportService{
  static final ReportService _instance = ReportService._internal();
  factory ReportService() => _instance;
  ReportService._internal();

  final TokenService tokenService = TokenService();

  Future<List<Report>> getAllReportType() async {
    try{
      final response = await http.get(
        Uri.parse("${URL.baseUrl}Admin/ReportType/GetAll"),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] != true || responseData['data'] == null) {
          return [];
        }

        final List<dynamic> postsJson = responseData['data'] as List<dynamic>;
        final posts = postsJson.map((json) {
          try {
            return Report.fromJson(json);
          } catch (e) {
            return null;
          }
        }).whereType<Report>().toList();

        return posts;
      } else {
        throw Exception('Failed to load report type');
      }
    } catch (e) {
      throw Exception('Failed to load report type: $e');
    }
  }
  Future<bool> createReport({
    required String content,
    required int postId,
    required int reportTypeId,
  }) async {
    try {
      final token = await getToken();

      final response = await http.post(
        Uri.parse("${URL.baseUrl}UserReport/ReportByPostId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'id': 0,
          'content': content,
          'postId': postId,
          'reportTypeId': reportTypeId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}