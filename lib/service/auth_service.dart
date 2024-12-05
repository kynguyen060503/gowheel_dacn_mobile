import 'dart:convert';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  //Login
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${URL.baseUrl}Authentication/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
  //Signup
  Future<Map<String, dynamic>> signup(String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${URL.baseUrl}Authentication/Signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
