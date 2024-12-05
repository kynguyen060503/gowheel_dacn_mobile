import 'dart:convert';
import 'package:gowheel_flutterflow_ui/models/api_response_model.dart';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final TokenService tokenService = TokenService();

  Future<User?> getMe() async {
    try {
      final token = await tokenService.getToken();
      if (token == null) {
        return null;
      }

      final response = await http.get(
        Uri.parse("${URL.baseUrl}Authentication/GetUser"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return User.fromJson(responseData);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateProfile(
      User user, {
        String? profileImage,
        String? cicImage,
        String? licenseImage,
      }) async {
    try {
      final token = await tokenService.getToken();
      if (token == null) return false;

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${URL.baseUrl}User/UpdateUserInfo"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add user fields
      if (user.name.isNotEmpty) request.fields['Name'] = user.name;
      if (user.phoneNumber != null) request.fields['PhoneNumber'] = user.phoneNumber!;
      if (user.birthday != null) request.fields['Birthday'] = user.birthday!.toIso8601String();

      // Add image files
      if (profileImage != null) {
        try {
          request.files.add(await http.MultipartFile.fromPath('Image', profileImage));
        } catch (e) {
          print('Error adding profile image: $e');
        }
      }

      if (cicImage != null) {
        try {
          request.files.add(await http.MultipartFile.fromPath('CIC', cicImage));
        } catch (e) {
          print('Error adding CIC image: $e');
        }
      }

      if (licenseImage != null) {
        try {
          request.files.add(await http.MultipartFile.fromPath('License', licenseImage));
        } catch (e) {
          print('Error adding license image: $e');
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResponse?> sendDriverRequest() async {
  try {
    final token = await tokenService.getToken();
    if (token == null) {
      return null;
    }

    final response = await http.put(
      Uri.parse('${URL.baseUrl}User/SendSubmitDriver'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return ApiResponse.fromJson(jsonResponse);
      } else {
        return ApiResponse(success: false, message: jsonResponse['message'], statusCode: jsonResponse['statusCode'], data: jsonResponse['data']);
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
  }
}