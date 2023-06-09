import 'dart:convert';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/tests/unenrolled.dart';

class AdminTestUnEnrollMentController extends GetxController
    with BaseController {
  RxBool isLoading = false.obs;
  RxString currentTestGuid = "".obs;

  List<UnEnrolled> unEnrolledUsers = List<UnEnrolled>.empty(growable: true).obs;
  ScrollController scrollController = ScrollController();

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
        data['message'],
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
