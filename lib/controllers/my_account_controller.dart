import 'dart:convert';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class MyAccountController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  RxBool isLoading = false.obs;
  final Map messages = {
    'USER_UPDATED_SUCCESSFULLY': 'User Updated Successfully.',
    'CONFIRM_PASSWORD_NOT_MATCHING': 'Confirm password not matching.',
    'PASSWORD_CONFIRM_FIELD_REQUIRED': 'Confirm password field is required.',
    'SETTINGS_SAVED': 'Settings Saved. Restart to see changes.',
  };

  Future updateUser(Map<String, String> userData, String userGuid) async {
    isLoading(true);
    String endpoint = "/users/update/$userGuid";
    var res =
        await BaseClient().formPost(endpoint, userData).catchError(handleError);
    isLoading(false);
    if (res == null) return "";
    Map data = json.decode(res);
    if (data['success']) {
      return messages[data['message']] ?? data['message'];
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: white,
      );
      return "";
    }
  }

  Future changePassword(Map<String, String> pwdData, String userGuid) async {
    isLoading(true);
    String endpoint = "/users/change_password/$userGuid";
    var res =
        await BaseClient().formPost(endpoint, pwdData).catchError(handleError);
    isLoading(false);
    if (res == null) return "";
    Map data = json.decode(res);
    if (data['success']) {
      return messages[data['message']] ?? data['message'] ?? "";
    } else {
      print(data['messages']['password_confirm']);
      Get.snackbar(
        "Error",
        data['messages'] != null
            ? data['messages']['password'] ??
                messages[data['messages']['password_confirm']] ??
                messages[data['messages']]
            : data['message'] ?? "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: white,
      );
      return "";
    }
  }
}
