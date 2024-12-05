import 'dart:convert';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:http/http.dart' as http;
import '../models/api_response_model.dart';
import '../url.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  TokenService tokenService = TokenService();
  
  Future<ApiResponse?> updateDriverLocation(String latitude, String longitude) async {
  try {
    final token = await tokenService.getToken();
    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('${URL.baseUrl}Driver/UpdateUserLocation/$latitude&&$longitude'),
      headers: {
        'accept': 'text/plain',
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