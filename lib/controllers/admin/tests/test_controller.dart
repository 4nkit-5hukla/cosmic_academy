import 'dart:convert';
// ignore: unused_import
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/landing.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';

class AdminTestController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  RxBool isLoading = false.obs;
  RxBool loadingQuestions = false.obs;
  RxString testSessionId = "".obs;
  RxString currentTestGuid = "".obs;
  RxInt attemptId = 0.obs;
  RxInt questionIndex = 0.obs;
  late Test currentTest;
  late List<dynamic> uploadedQuestions;
  List<Question> testQuestions = List<Question>.empty(growable: true).obs;
  final Map messages = {
    'TEST_NOT_FOUND': 'TEST Not Found.',
    'TEST_DELETED_SUCCESSFULLY': 'Test Deleted Successfully.',
    'TEST_CREATED_SUCCESSFULLY': 'Test Added Successfully.',
    'TEST_UPDATED_SUCCESSFULLY': 'Test Updated Successfully.',
    'TEST_SAVED_SUCCESSFULLY': 'Test Submitted Successfully.',
    'TEST_SUBMITTED_SUCCESSFULLY': 'Test Submitted Successfully.',
    'TEST_SESSION_EXPIRED': 'Test Session Expired.',
    'TEST_SESSION_NOT_EXISTS': 'Invalid Test Session.',
    'STATUS_UPDATED': 'Test status updated.',
    'QUESTION_ADDED_SUCCESSFULLY': 'Question added successfully.',
    'FILE_UPLOADED': 'File Uploaded.',
    'IMPORTED': 'Questions import successfully.',
    'TEST_HAS_NO_QUESTIONS': 'Test sas no questions.',
    'TEST_SETTINGS_UPDATED_SUCCESSFULLY': 'Test Settings Updated Successfully.',
    'QUESTIONS_SAVED_SUCCESSFULLY': 'Questions Imported Successfully.',
  };

  List<Question> getFilteredQuestions(String term) {
    return testQuestions
        .where((element) =>
            element.question.toLowerCase().contains(term.toLowerCase()))
        .toList();
  }

  Future fetchTestInfo() async {}

  Future fetchTest() async {
    if (currentTestGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/tests/view/$currentTestGuid",
          )
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        await fetchTestInfo();
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

  Future<String> addUpdateTest(dynamic testData) async {
    isLoading(true);
    String endpoint = currentTestGuid.value == ""
        ? "/tests/add"
        : "/tests/add/$currentTestGuid";
    var res =
        await BaseClient().formPost(endpoint, testData).catchError(handleError);
    if (res == null) return "";
    isLoading(false);
    Map data = json.decode(res);
    if (data['success'] &&
        (data['message'] == 'TEST_CREATED_SUCCESSFULLY' ||
            data['message'] == 'TEST_UPDATED_SUCCESSFULLY')) {
      await fetchTest();
      return messages[data['message']] ?? "Success";
    } else {
      return messages[data['message']] ?? "Something Went Wrong";
    }
  }

  Future<String> saveTestSettings(dynamic testSettings) async {
    isLoading(true);
    String endpoint = "/tests/settings/$currentTestGuid";
    var res = await BaseClient()
        .formPost(endpoint, testSettings)
        .catchError(handleError);
    if (res == null) return "";
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true &&
        data['message'] == 'TEST_SETTINGS_UPDATED_SUCCESSFULLY') {
      await fetchTest();
      return messages[data['message']];
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
      return "";
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
      if (res == null) return;
      Map data = json.decode(res);
      isLoading(false);
      if (data['success']) {
        if (data['message'] == 'STATUS_UPDATED') {
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

  Future<String> deleteTest(bool deleteForever) async {
    if (currentTestGuid.value.isEmpty) return "";
    isLoading(true);
    var res = await BaseClient()
        .delete("/tests/delete/$currentTestGuid")
        .catchError(handleError);
    isLoading(false);
    Map data = json.decode(res);
    if (data['success'] == true) {
      return messages[data['message']] ?? "Success.";
    } else {
      return messages[data['message']] ?? "Something went wrong.";
    }
  }

  Future bulkUploadQuestions(
      String userGuid, String fieldName, String filePath) async {
    String endpoint = "/tests/upload_questions/$currentTestGuid";
    isLoading(true);
    var res = await BaseClient()
        .formPost(endpoint, {"created_by": userGuid}, fieldName, filePath)
        .catchError(handleError);
    isLoading(false);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success']) {
      if (data['message'] == 'FILE_UPLOADED') {
        uploadedQuestions = data['payload'];
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

  Future<dynamic> saveImportedQuestions(Map<String, String> quesData) async {
    if (currentTestGuid.value != "") {
      isLoading(true);
      String endpoint = "/tests/save_uploaded_questions/$currentTestGuid";
      var res = await BaseClient()
          .formPost(
            endpoint,
            quesData,
          )
          .catchError(
            handleError,
          );
      Map data = json.decode(res);
      isLoading(false);
      if (data['success'] || data['message'] == "TEST_SUBMITTED_SUCCESSFULLY") {
        return messages[data['message']];
      } else {
        Get.snackbar(
          "Error",
          messages[data['message']] ?? "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: b3.shade500,
          colorText: Colors.white,
        );
        return "";
      }
    }
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
      if (res == null) return "";
      Map data = json.decode(res);
      isLoading(false);
      if (data['success'] || data['message'] == "TEST_SUBMITTED_SUCCESSFULLY") {
        return messages[data['message']];
      } else {
        Get.snackbar(
          "Error",
          messages[data['message']] ?? "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: b3.shade500,
          colorText: Colors.white,
        );
        return "";
      }
    }
  }
}
