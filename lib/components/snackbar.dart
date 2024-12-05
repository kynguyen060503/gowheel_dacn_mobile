import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Snackbar {
  static void showAwesomeSnackbar(String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
      duration: const Duration(seconds: 3),
    );

    Get.closeCurrentSnackbar();
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  static showError(String title, String message) {
    showAwesomeSnackbar(title, message, ContentType.failure);
  }

  static showSuccess(String title, String message) {
    showAwesomeSnackbar(title, message, ContentType.success);
  }

  static showWarning(String title, String message) {
    showAwesomeSnackbar(title, message, ContentType.warning);
  }

  static showHelp(String title, String message) {
    showAwesomeSnackbar(title, message, ContentType.help);
  }
}