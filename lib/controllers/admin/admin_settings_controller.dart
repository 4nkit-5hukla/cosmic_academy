import 'dart:convert';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class AdminSettingsController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  RxBool isLoading = false.obs;
  RxString themeColor = "".obs;
  RxBool allowUserRegistration = false.obs;
  RxBool autoGenerateUsername = false.obs;
  RxBool autoApproveUser = false.obs;
  RxString defaultUserRole = student.value.obs;
  RxBool userName = false.obs;
  RxBool mobile = false.obs;
  RxBool email = false.obs;
  RxString token = "".obs;
  final Map messages = {
    'ATLEAST_ONE_FIELD_IS_REQUIRED': 'Failed At least one field is required.',
    'SETTINGS_SAVED': 'Settings Saved. Restart to see changes.',
  };

  Future getTheme() async {
    isLoading(true);
    String endpoint = "/settings/general/get_theme";
    var res = await BaseClient().get(endpoint).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      if (isDebug) {
        print(data);
      }
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  Future<String> saveTheme(String themeColor, String userGuid) async {
    isLoading(true);
    String endpoint = "/settings/general/save_theme";
    var res = await BaseClient().formPost(endpoint, {
      "theme_color": themeColor,
      "created_by": userGuid,
    }).catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      return messages[data['message']] ?? data['message'];
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "";
    }
  }

  void getCommon() async {
    isLoading(true);
    String endpoint = "/settings/registration/common";
    var res = await BaseClient().get(endpoint).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      autoApproveUser(data['payload']['auto_approve_user'] == 'true');
      allowUserRegistration(
          data['payload']['allow_user_registration'] == 'true');
      autoGenerateUsername(data['payload']['auto_generate_username'] == 'true');
      defaultUserRole(data['payload']['default_user_role']);
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  Future<String> saveCommon(Map<String, String> payloadObj) async {
    isLoading(true);
    String endpoint = "/settings/registration/common";
    var res = await BaseClient()
        .formPost(endpoint, payloadObj)
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      return messages[data['message']] ?? data['message'];
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "";
    }
  }

  void getFields() async {
    isLoading(true);
    String endpoint = "/settings/registration/valid_fields";
    var res = await BaseClient().get(endpoint).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      mobile(data['payload']['fields']['mobile'] == 'true');
      email(data['payload']['fields']['email'] == 'true');
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  Future<String> saveFields(Map<String, String> payloadObj) async {
    isLoading(true);
    String endpoint = "/settings/registration/valid_fields";
    var res = await BaseClient()
        .formPost(endpoint, payloadObj)
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      return messages[data['message']] ?? data['message'];
    } else {
      return messages[data['message']] ?? "Something went wrong.";
    }
  }
}
