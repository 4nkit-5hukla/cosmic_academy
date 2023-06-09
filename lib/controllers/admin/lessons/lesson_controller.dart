import 'dart:convert';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/lessons/lesson.dart';
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/courses.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/manage_course.dart';

class AdminLessonController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final Map messages = {
    'LESSON_NOT_FOUND': 'Lesson Not Found.',
    'LESSON_DELETED_SUCCESSFULLY': 'Lesson Deleted Successfully.',
    'LESSON_CREATED_SUCCESSFULLY': 'Lesson Added Successfully.',
    'LESSON_UPDATED_SUCCESSFULLY': 'Lesson Updated Successfully.',
    'LESSON_SAVED_SUCCESSFULLY': 'Lesson Submitted Successfully.',
    'LESSON_SESSION_EXPIRED': 'Lesson Session Expired.',
    'LESSON_SESSION_NOT_EXISTS': 'Invalid Lesson Session.',
    'STATUS_UPDATED': 'Lesson Updated.',
    'QUESTION_ADDED_SUCCESSFULLY': 'Question Added Successfully.',
  };
  final List<FilterOption> statusOptions = [
    FilterOption(
      value: '',
      label: 'All',
    ),
    FilterOption(
      value: '0',
      label: 'Unpublished',
    ),
    FilterOption(
      value: '1',
      label: 'Published',
    ),
    FilterOption(
      value: '2',
      label: 'Archived',
    ),
  ];
  RxBool isLoading = false.obs;
  RxBool loadingQuestions = false.obs;
  RxString currentLessonGuid = "".obs;
  RxInt attemptId = 0.obs;
  RxInt questionIndex = 0.obs;
  late Lesson currentLesson;
  List<Question> testQuestions = List<Question>.empty(growable: true).obs;
  String getStatusLabel(String status) {
    return statusOptions
        .firstWhere(
          (element) => element.value == status,
        )
        .label;
  }

  void fetchLesson() async {
    if (currentLessonGuid.isNotEmpty) {
      print(currentLessonGuid.value);
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/lesson/view/$currentLessonGuid",
          )
          .catchError(
            handleError,
          );
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        currentLesson = Lesson.fromJson(
          data['payload'],
        );
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

  void addUpdateLesson(dynamic courseData) async {
    isLoading(true);
    String endpoint = currentLessonGuid.value == ""
        ? "/lesson/create"
        : "/lesson/update/$currentLessonGuid";
    var res = await BaseClient()
        .formPost(
          endpoint,
          courseData,
        )
        .catchError(
          handleError,
        );
    if (res == null) return;
    Map data = json.decode(
      res,
    );
    isLoading(false);
    if (data['success']) {
      if (data['message'] == 'LESSON_CREATED_SUCCESSFULLY' ||
          data['message'] == 'LESSON_UPDATED_SUCCESSFULLY') {
        String adminManageCourse = AdminManageCourse.routePath;
        String currentCourseGuid = courseController.currentCourseGuid.value;
        if (currentLessonGuid.value != "") {
          Get.back();
        } else {
          Get.offNamedUntil(
            AdminCoursesScreen.routeName,
            (route) => false,
          );
          Get.toNamed(
            "$adminManageCourse/$currentCourseGuid",
          );
        }
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

  void updateLessonStatus(String status) async {
    if (currentLessonGuid.value != "") {
      isLoading(true);
      String endpoint = "/lesson/status/$currentLessonGuid";
      var res = await BaseClient().formPost(
        endpoint,
        {
          'status': status,
          'updated_by': authController.userGuId.value,
        },
      ).catchError(
        handleError,
      );
      if (res == null) return;
      Map data = json.decode(res);
      isLoading(false);
      if (data['success']) {
        if (data['message'] == 'STATUS_UPDATED') {
          currentLesson.status = status;
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
}
