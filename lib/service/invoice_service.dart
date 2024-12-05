import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/invoice_model.dart';
import '../url.dart';
import 'storage_service.dart';

class InvoiceService {
  final TokenService tokenService = TokenService();

  Future<List<Invoice>> getInvoices() async {
  try {
    final token = await tokenService.getToken();
    final response = await http.get(
      Uri.parse('${URL.baseUrl}User/Invoice/GetPersonalInvoices'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Parsed Data: $data');

      // Add more detailed error handling
      if (data['data'] == null) {
        print('No "data" key found in response');
        return [];
      }

      try {
        return (data['data'] as List)
            .map((json) => Invoice.fromJson(json))
            .toList();
      } catch (e) {
        print('Error parsing invoices: $e');
        return [];
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please log in again');
    } else {
      throw Exception('Failed to fetch invoices: ${response.statusCode}');
    }
  } catch (e) {
    print('Service error details: $e');
    throw Exception('Service error: $e');
  }
}
}