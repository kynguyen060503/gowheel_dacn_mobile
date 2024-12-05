import 'dart:convert';
import 'package:gowheel_flutterflow_ui/models/amenity_model.dart';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:http/http.dart' as http;


class AmenityService {
  static final AmenityService  _instance = AmenityService._internal();
  factory AmenityService() => _instance;
  AmenityService._internal();
  
  final TokenService tokenService = TokenService();

  Future<List<Amenity>> fetchAmenities() async {
    try {
      final token = await tokenService.getToken();
      final response = await http.get(
        Uri.parse("${URL.baseUrl}Admin/Amenity/GetAll"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          return (responseData['data'] as List)
              .map((json) => Amenity.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load amenities: ${responseData['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load amenities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching amenities: $e');
    }
  }
}