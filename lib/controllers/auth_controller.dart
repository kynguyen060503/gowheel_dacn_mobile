import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import 'package:gowheel_flutterflow_ui/pages/sign_in.dart';
import 'package:gowheel_flutterflow_ui/root.dart';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final tokenService = TokenService();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _authService.signIn(email, password);
      if (response['success'] == false) {
        Snackbar.showError('Error!', response['message']);
      } else {
        Snackbar.showSuccess('Success!', 'Logged in successfully');
        final token = response['message'];
        tokenService.saveToken(token);
        Get.offAll(() => const RootPage());
      }
    } catch (e) {
      Snackbar.showWarning('Connection Error!', 'Lost connection to server!');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email,String username , String password) async {
    isLoading.value = true;
    try {
      final response = await _authService.signup(email, username, password);
      if (response['success'] == false) {
        Snackbar.showError("Error", response['message']);
      } else {
        Snackbar.showSuccess("Success", "Signup successfully!");
        Get.offAll(() => const SignInWidget(),
            transition: Transition.size,
            duration: const Duration(seconds: 1)
        );
      }
    } catch(e) {
      Snackbar.showWarning('Connection Error!', 'Lost connection to server!');
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      tokenService.deleteToken();
      Snackbar.showSuccess("Success", "Loggout successfully!");
      Get.offAll(() => const SignInWidget());
    } catch (e) {
      Snackbar.showError("Error", "Something went wrong, we cannot logout for you!");
    }
  }
}
