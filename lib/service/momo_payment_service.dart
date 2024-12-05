import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../url.dart';

class MomoPaymentService {
  final TokenService tokenService = TokenService();

  Future<void> createAndLaunchMomoPayment(int invoiceId) async {
    var token = await tokenService.getToken();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${URL.baseUrl}User/Invoice/MomoPayment/$invoiceId'),
      );
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'accept': 'text/plain',
      });
      request.fields['isMobile'] = 'true';
      
      var response = await request.send();
      var paymentUrl = await response.stream.bytesToString();
      print('Payment URL from API: $paymentUrl'); // Log URL

      if (response.statusCode == 200) {
        // final momoAppUrl = convertToMomoAppUrl(paymentUrl);
        // print('MoMo App URL: $momoAppUrl'); // Log URL chuyển đổi
        final success = await launchMomoApp(paymentUrl);
        if (!success) {
          throw Exception('Could not launch MoMo app');
        }
      } else {
        throw Exception('Failed to create payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating payment: $e');
    }
  }

  // String convertToMomoAppUrl(String webUrl) {
  // if (webUrl.contains('https://test-payment.momo.vn')) {
  //   return webUrl.replaceFirst('https://test-payment.momo.vn', 'momo://app');
  // }
  // throw Exception('Invalid MoMo payment URL: $webUrl');
  // }


  Future<bool> launchMomoApp(String paymentUrl) async {
    try {
      final uri = Uri.parse(paymentUrl);
      if (await canLaunchUrl(uri)) {
        print('Launching MoMo app with URL: $paymentUrl');
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        print('Cannot launch URL: $paymentUrl');
      }
      return false;
    } catch (e) {
      print('Error launching MoMo app: $e');
      return false;
    }
  }
}