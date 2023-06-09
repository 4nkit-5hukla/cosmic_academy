import 'dart:convert';
// ignore: unused_import
import 'dart:ffi';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';
import 'package:cosmic_assessments/view/screens/student/landing.dart';

class StudentTestController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  RxBool isLoading = false.obs;
  RxBool loadingQuestions = false.obs;
  RxString testSessionId = "".obs;
  RxString currentTestGuid = "".obs;
  RxInt attemptId = 0.obs;
  RxInt questionIndex = 0.obs;
  late Test currentTest;
  List<Question> testQuestions = List<Question>.empty(growable: true).obs;
  final Map messages = {
    'TEST_NOT_FOUND': 'TEST Not Found.',
    'TEST_DELETED_SUCCESSFULLY': 'Test Deleted Successfully.',
    'TEST_CREATED_SUCCESSFULLY': 'Test Added Successfully.',
    'TEST_UPDATED_SUCCESSFULLY': 'Test Updated Successfully.',
    'TEST_SUBMITTED_SUCCESSFULLY': 'Test Submitted Successfully.',
    'TEST_SAVED_SUCCESSFULLY': 'Test Submitted Successfully.',
    'TEST_SESSION_EXPIRED': 'Test Session Expired.',
    'TEST_SESSION_NOT_EXISTS': 'Invalid Test Session.',
    'STATUS_UPDATED': 'Test Status Updated.',
    'QUESTION_ADDED_SUCCESSFULLY': 'Question Added Successfully.',
    'MAX_ATTEMPTS_REACHED': 'Already taken max attempts allowed.',
  };

  List<Question> getFilteredQuestions(String term) {
    return testQuestions
        .where((element) =>
            element.question.toLowerCase().contains(term.toLowerCase()))
        .toList();
  }

  Future fetchTest() async {
    if (currentTestGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get("/tests/view/$currentTestGuid")
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        currentTest = Test.fromMap(data['payload']);
      } else {
        Get.snackbar(
          "Error",
          data['message'],
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: b3,
          colorText: white,
        );
      }
      isLoading(false);
      update();
    }
  }

  void doPublishUnPublishTest(String status) async {
    if (currentTestGuid.value != "") {
      isLoading(true);
      String endpoint = "/tests/status/$currentTestGuid";
      var res = await BaseClient().formPost(
        endpoint,
        {
          'status': status,
          'updated_by': 'CA000030',
        },
      ).catchError(
        handleError,
      );
      print(res);
      if (res == null) return;
      Map data = json.decode(res);
      isLoading(false);
      if (data['success']) {
        if (data['message'] == 'STATUS_UPDATED') {
          print(data['message']);
          currentTest.status = status;
          Get.snackbar(
            "Success",
            messages[data['message']],
            icon: const Icon(
              Icons.check,
              color: white,
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: globalController.mainColor,
            colorText: white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: b3,
          colorText: white,
        );
      }
      update();
    }
  }

  void deleteTest(bool deleteForever) async {
    isLoading(true);
    var res = await BaseClient()
        .delete("/tests/delete/$currentTestGuid")
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    print(data);
    isLoading(false);
    if (data['success'] == true) {
      Get.offNamedUntil(StudentLandingScreen.routeName, (route) => false);
      Get.toNamed(
        AdminTestsScreen.routeName,
      );
      Get.snackbar(
        "Success",
        messages[data['message']],
        icon: const Icon(
          Icons.check,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: globalController.mainColor,
        colorText: white,
      );
    } else {
      Get.snackbar(
        "Error",
        messages[data['message']] ?? "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: b3,
        colorText: white,
      );
    }
    update();
  }

  Future generateSession(String userId) async {
    const Uuid uuid = Uuid();
    int unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String unixTimeString = unixTime.toString();
    testSessionId(
      uuid.v5(
        Uuid.NAMESPACE_OID,
        "${userId}_${currentTestGuid}_$unixTimeString",
      ),
    );
    return testSessionId.value;
  }

  Future takeTest(String userId, String sessionId) async {
    if (currentTestGuid.value != "") {
      isLoading(true);
      String endpoint = "/tests/take_test/$currentTestGuid";
      var res = await BaseClient().formPost(
        endpoint,
        {
          'user_guid': userId,
          'set_session': sessionId,
        },
      ).catchError(
        handleError,
      );
      isLoading(false);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        attemptId(data['payload']['attempt_id']);
        return data['payload']['attempt_id'];
      } else {
        Get.snackbar(
          "Error",
          messages[data["message"]] ?? "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: b3,
          colorText: white,
        );
      }
      update();
    }
  }

  Future<dynamic> submitTest(dynamic testData) async {
    if (currentTestGuid.value != "") {
      isLoading(true);
      String endpoint = "/tests/submit_test/$currentTestGuid";
      var res = await BaseClient()
          .formPost(
            endpoint,
            testData,
          )
          .catchError(
            handleError,
          );
      print(res);
      if (res == null) return "";
      Map data = json.decode(res);
      isLoading(false);
      print(data);
      if (data['success'] || data['message'] == "TEST_SUBMITTED_SUCCESSFULLY") {
        return messages[data['message']];
      } else {
        Get.snackbar(
          "Error",
          messages[data['message']] ?? "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: b3.shade500,
          colorText: white,
        );
        return "";
      }
    }
  }
}
