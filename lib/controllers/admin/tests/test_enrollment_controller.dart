import 'dart:convert';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/tests/enrolled.dart';
import 'package:cosmic_assessments/models/tests/unenrolled.dart';
import 'package:cosmic_assessments/models/tests/test.dart';

class AdminTestEnrollMentController extends GetxController with BaseController {
  RxBool isLoading = false.obs;
  RxString currentTestGuid = "".obs;
  late Test currentTest;
  List<Enrolled> enrolledUsers = List<Enrolled>.empty(growable: true).obs;
  List<UnEnrolled> unEnrolledUsers = List<UnEnrolled>.empty(growable: true).obs;
  ScrollController scrollController = ScrollController();
  final Map messages = {
    'USERS_ENROLED': 'Users Enrolled.',
    'USERS_UNENROLED': 'Users Unenrolled.',
    'ENROLMENTS_NOT_FOUND': 'Enrollments not found.',
  };

  Future getEnrolledUsers() async {
    String endpoint = "/tests/enrolments/$currentTestGuid";
    isLoading(true);
    var res = await BaseClient().formPost(endpoint, {}).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success'] && data['message'] == 'ENROLMENTS_FOUND') {
      enrolledUsers = enrolledFromJson(json.encode(data['payload']));
    } else if (data['message'] != "ENROLMENTS_NOT_FOUND") {
      Get.snackbar(
        "Error",
        messages[data['message']] ?? "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading(false);
    update();
  }

  Future getUnEnrolledUsers() async {
    String endpoint = "/tests/notenroled/$currentTestGuid";
    isLoading(true);
    var res = await BaseClient().formPost(endpoint, {}).catchError(handleError);
    isLoading(false);
    Map data = json.decode(res);
    if (data['success'] && data['message'] == 'USERS_FOUND') {
      unEnrolledUsers = unEnrolledFromJson(json.encode(data['payload']));
    } else {
      Get.snackbar(
        "Error",
        messages[data['message']] ?? "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: white,
      );
    }
    update();
  }

  Future enrollUsers(Map<String, String> payloadObj) async {
    String endpoint = "/tests/enrol/$currentTestGuid";
    var res = await BaseClient()
        .formPost(endpoint, payloadObj)
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success'] && data['message'] == 'USERS_ENROLED') {
      await getEnrolledUsers();
      Get.back();
      Get.snackbar(
        "Success",
        messages[data['message']] ?? data['message'],
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: b1,
        colorText: white,
      );
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
    }
    update();
  }

  Future unEnrollUsers(Map<String, String> payloadObj) async {
    String endpoint = "/tests/unenrol/$currentTestGuid";
    var res = await BaseClient()
        .formPost(endpoint, payloadObj)
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success'] && data['message'] == 'USERS_UNENROLED') {
      await getEnrolledUsers();
      Get.snackbar(
        "Success",
        messages[data['message']] ?? data['message'],
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: b1,
        colorText: white,
      );
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
    }
    update();
  }
}
