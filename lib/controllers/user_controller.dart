import 'dart:io';

import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';

import '../models/user_model.dart';
import '../service/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  RxBool isLoading = false.obs;
  Rxn<User> currentUser = Rxn<User>();

   // Image file handlers
  Rx<File?> newProfileImage = Rx<File?>(null);
  Rx<File?> newCICImage = Rx<File?>(null);
  Rx<File?> newLicenseImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    getMe();
  }

  void setProfileImage(File image) {
    newProfileImage.value = image;
  }

  void setCICImage(File image) {
    newCICImage.value = image;
  }

  void setLicenseImage(File image) {
    newLicenseImage.value = image;
  }

  void updateBirthday(DateTime date) {
    if (currentUser.value != null) {
      final updatedUser = User(
        id: currentUser.value!.id,
        name: currentUser.value!.name,
        license: currentUser.value!.license,
        image: currentUser.value!.image,
        cic: currentUser.value!.cic,
        phoneNumber: currentUser.value!.phoneNumber,
        reportPoint: currentUser.value!.reportPoint,
        birthday: date,
        roles: currentUser.value!.roles,
      );
      currentUser.value = updatedUser;
      currentUser.refresh();
    }
  }


  Future<void> getMe() async {
    try {
      isLoading.value = true;
      final user = await _userService.getMe();
      if (user != null) {
        currentUser.value = user;
      }
    } catch (e) {
      Get.snackbar("Error", "Lost connection to server!");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile() async {
    if (currentUser.value == null) return false;

    try {
      isLoading.value = true;
      final success = await _userService.updateProfile(
        currentUser.value!,
        profileImage: newProfileImage.value?.path,
        cicImage: newCICImage.value?.path,
        licenseImage: newLicenseImage.value?.path,
      );

      if (success) {
        await getMe();
        Snackbar.showSuccess('Success', 'Profile updated successfully');
        newProfileImage.value = null;
        newCICImage.value = null;
        newLicenseImage.value = null;
      } else {
        Snackbar.showError('Error', 'Could not update profile');
      }
      return success;
    } catch (e) {
      Snackbar.showError('Error', 'Connection lost: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendDriverRequest() async {
    isLoading.value = true;
    try {
      final response = await _userService.sendDriverRequest();
      if (response != null && response.success) {
      Snackbar.showSuccess("Success", "Request sent!");
    } else {
      Snackbar.showError("Error", response?.message ?? "Failed to sent request!");
    }
    } catch (e) {
      Snackbar.showWarning('Error', 'Error while sent request!');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    await getMe();
  }

}