import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import 'package:gowheel_flutterflow_ui/controllers/post_controler.dart';
import 'package:gowheel_flutterflow_ui/controllers/user_controller.dart';
import 'package:gowheel_flutterflow_ui/pages/sign_in.dart';
import 'package:gowheel_flutterflow_ui/root.dart';
import 'package:gowheel_flutterflow_ui/service/hub_service.dart';
import 'package:gowheel_flutterflow_ui/service/storage_service.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final PostController _postController = Get.find<PostController>();
  final tokenService = TokenService();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _authService.signIn(email, password);
      if (response['success'] == false) {
        Snackbar.showError('Error!', response['message']);
      } else {
        final token = response['message'];
        tokenService.saveToken(token);
        HubService.instance.connect();
        Get.offAll(() => const RootPage());
        Snackbar.showSuccess('Success!', 'Logged in successfully');
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
        Get.offAll(() => const SignInWidget(),
            transition: Transition.size,
            duration: const Duration(seconds: 1)
        );
        Snackbar.showSuccess("Success", "Signup successfully!");
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
      Get.find<UserController>().currentUser.value = null;
      Snackbar.showSuccess("Success", "Loggout successfully!");
      _postController.resetPageIndex();
      HubService.instance.disconnect();
      Get.offAll(() => const SignInWidget());
    } catch (e) {
      Snackbar.showError("Error", "Something went wrong, we cannot logout for you!");
    }
  }
}
