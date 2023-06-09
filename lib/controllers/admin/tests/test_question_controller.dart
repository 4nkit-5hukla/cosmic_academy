import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class TestQuestionController extends GetxController with BaseController {
  RxBool isLoading = false.obs;
  RxBool loadingQuestions = false.obs;
  RxString currentTestGuid = "".obs;
  RxString currentTestQuestionGuid = "".obs;
  late Test currentTest;
  late Question currentTestQuestion;
  List<Question> testQuestions = List<Question>.empty(growable: true).obs;
  final Map messages = {
    'CHOICE_FIELD_REQUIRED': 'Choices are required.',
    'STATUS_UPDATED': 'Test Status Updated.',
    'QUESTION_ADDED_SUCCESSFULLY': 'Question Added Successfully.',
    'QUESTION_UPDATED_SUCCESSFULLY': 'Question Updated Successfully.',
  };

  List<Question> getFilteredQuestions(String term) {
    print(term);
    return testQuestions
        .where((element) =>
            element.question.toLowerCase().contains(term.toLowerCase()))
        .toList();
  }

  Future fetchTestQuestion() async {
    if (currentTestQuestionGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get("/tests/get_question/$currentTestQuestionGuid/1")
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['message'] == 'QUESTION_FOUND') {
        currentTestQuestion = Question.fromMap(data['payload']);
      } else {
        Get.snackbar(
          "Error",
          data['message'],
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
  }

  Future<String> addQuestion(
      dynamic questionData, String? fieldName, String? filePath) async {
    isLoading(true);
    String endpoint = "/tests/create_question/$currentTestGuid";
    var res = await BaseClient()
        .formPost(endpoint, questionData, fieldName, filePath)
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] && data['message'] == 'QUESTION_ADDED_SUCCESSFULLY') {
      return messages[data['message']] ?? 'Success';
    } else {
      return data['message'] != ''
          ? "Validation Failed"
          : messages[data['message']] ?? 'Something went wrong';
    }
  }

  Future<String> updateQuestion(
      dynamic questionData, String? fieldName, String? filePath) async {
    if (currentTestGuid.value.isEmpty &&
        currentTestQuestionGuid.value.isEmpty) {
      return "";
    }
    isLoading(true);
    String endpoint =
        "/tests/update_question/$currentTestGuid/$currentTestQuestionGuid";
    var res = await BaseClient()
        .formPost(endpoint, questionData, fieldName, filePath)
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] && data['message'] == 'QUESTION_UPDATED_SUCCESSFULLY') {
      return messages[data['message']] ?? 'Success';
    } else {
      return data['message'] != ''
          ? "Validation Failed"
          : messages[data['message']] ?? 'Something went wrong';
    }
  }
}
