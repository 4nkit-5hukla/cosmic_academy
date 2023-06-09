import 'dart:convert';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/courses/course.dart';
import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/courses.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/manage_course.dart';
import 'package:cosmic_assessments/view/screens/admin/landing.dart';

class AdminCourseController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  RxBool isLoading = false.obs;
  RxString currentCourseGuid = "".obs;
  late Course currentCourse;
  final Map messages = {
    'COURSE_NOT_FOUND': 'TEST Not Found.',
    'COURSE_DELETED_SUCCESSFULLY': 'Course Deleted Successfully.',
    'COURSE_CREATED_SUCCESSFULLY': 'Course Added Successfully.',
    'COURSE_UPDATED_SUCCESSFULLY': 'Course Updated Successfully.',
    'COURSE_SAVED_SUCCESSFULLY': 'Course Submitted Successfully.',
    'COURSE_SESSION_EXPIRED': 'Course Session Expired.',
    'COURSE_SESSION_NOT_EXISTS': 'Invalid Course Session.',
    'STATUS_UPDATED': 'Course Status Updated.',
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
  String getStatusLabel(String status) {
    return statusOptions
        .firstWhere(
          (element) => element.value == status,
        )
        .label;
  }

  void fetchCourse() async {
    if (currentCourseGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/course/view/$currentCourseGuid",
          )
          .catchError(
            handleError,
          );
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        currentCourse = Course.fromMap(
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

  void addUpdateCourse(dynamic courseData) async {
    isLoading(true);
    String endpoint = currentCourseGuid.value == ""
        ? "/course/create"
        : "/course/update/$currentCourseGuid";
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
      if (data['message'] == 'COURSE_CREATED_SUCCESSFULLY' ||
          data['message'] == 'COURSE_UPDATED_SUCCESSFULLY') {
        Get.offNamedUntil(
          AdminCoursesScreen.routeName,
          (route) => false,
        );
        if (currentCourseGuid.value != "") {
          Get.toNamed(
            "${AdminManageCourse.routePath}/${currentCourseGuid.value}",
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

  void doPublishUnPublishCourse(String status) async {
    if (currentCourseGuid.value != "") {
      isLoading(true);
      String endpoint = "/course/status/$currentCourseGuid";
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
          currentCourse.status = status;
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

  void changeStatus(String status) async {
    return doPublishUnPublishCourse(status);
  }

  void deleteCourse(bool deleteForever) async {
    isLoading(true);
    var res = await BaseClient()
        .delete(
          "/course/delete/$currentCourseGuid",
        )
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true) {
      Get.offNamedUntil(
        AdminLandingScreen.routeName,
        (route) => false,
      );
      Get.toNamed(
        AdminCoursesScreen.routeName,
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
}
