import 'dart:convert';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/lessons/lesson.dart';
import 'package:cosmic_assessments/models/lessons/lesson_content.dart';
import 'package:cosmic_assessments/models/lessons/lesson_section.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class AdminLessonSectionController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.find<AdminLessonsController>();
  final Map messages = {
    'SECTION_ADDED': 'Section Added Successfully.',
    'SECTION_NOT_FOUND': 'Section Not Found.',
    'SECTION_DELETED_SUCCESSFULLY': 'Section Deleted Successfully.',
    'SECTION_CREATED_SUCCESSFULLY': 'Section Added Successfully.',
    'SECTION_UPDATED': 'Section Updated Successfully.',
    'CONTENT_NOT_FOUND': 'Content Not Found.',
    'LESSON_SAVED_SUCCESSFULLY': 'Lesson Submitted Successfully.',
    'LESSON_SESSION_EXPIRED': 'Lesson Session Expired.',
    'LESSON_SESSION_NOT_EXISTS': 'Invalid Lesson Session.',
    'STATUS_UPDATED': 'Content Updated.',
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
  RxBool loadingContent = false.obs;
  RxString currentLessonGuid = "".obs;
  RxString currentSectionGuid = "".obs;
  late Lesson currentLesson;
  List<LessonSection> currentLessonSections =
      List<LessonSection>.empty(growable: true).obs;
  List<LessonContent> currentLessonContent =
      List<LessonContent>.empty(growable: true).obs;
  late LessonSection currentSection;
  late LessonContent currentContent;
  ScrollController scrollController = ScrollController();
  String getStatusLabel(String status) {
    return statusOptions
        .firstWhere(
          (element) => element.value == status,
        )
        .label;
  }

  void deleteSectionFromList(String sectionId) {
    currentLessonSections.removeWhere(
      (section) => sectionId == section.id,
    );
  }

  void deleteLessonFromList(String contentGuid) {
    currentLessonContent.removeWhere(
      (content) => contentGuid == content.contentId,
    );
  }

  Future fetchContent() async {
    if (currentLessonGuid.isNotEmpty) {
      if (isDebug) {
        print(currentLessonGuid.value);
      }
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/lesson/content/list/$currentLessonGuid",
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
        List<LessonContent> lessons = List<LessonContent>.from(
          data['payload']['content'].map(
            (x) => LessonContent.fromJson(
              x,
            ),
          ),
        );
        lessons.sort((a, b) => a.position.compareTo(b.position));
        currentLessonContent.assignAll(lessons);
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

  void reorderContent(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final LessonContent item = currentLessonContent.removeAt(oldIndex);
    currentLessonContent.insert(
      newIndex,
      item,
    );
  }

  void updateStatus(String contentGuid, String status) {
    int index = currentLessonContent
        .indexWhere((content) => contentGuid == content.contentId);
    currentLessonContent.assignAll(
      List.from(
        currentLessonContent.map(
          (content) {
            if (currentLessonContent.indexOf(content) == index) {
              LessonContent newContent = content;
              newContent.status = status;
              return newContent;
            } else {
              return content;
            }
          },
        ),
      ),
    );
  }

  Future uploadFile(String fieldName, String filePath, String userGuid) async {
    String endpoint =
        "/lesson/content/upload/${lessonsController.currentLessonGuid.value}";
    var res = await BaseClient()
        .formPost(
          endpoint,
          {'created_by': 'CA00001'},
          fieldName,
          filePath,
        )
        .catchError(
          handleError,
        );
    if (res == null) return;
    Map data = json.decode(
      res,
    );
    fetchContent();
  }

  void addUpdateSection(
    dynamic contentData, [
    bool updateContent = false,
  ]) async {
    isLoading(true);
    String endpoint = !updateContent
        ? "/lesson/add_section/${lessonsController.currentLessonGuid}"
        : "/lesson/edit_section/${lessonsController.currentLessonGuid}/${currentSection.id}";
    var res = await BaseClient()
        .formPost(
          endpoint,
          contentData,
        )
        .catchError(
          handleError,
        );
    if (res == null) return;
    Map data = json.decode(
      res,
    );
    isLoading(false);
    update();
    if (data['success']) {
      if (data['message'] == 'SECTION_ADDED' ||
          data['message'] == 'SECTION_UPDATED') {
        await fetchLessonSection();
        Get.back();
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
  }

  void arrangeContent() async {
    Map<String, String> arrangeData = {
      'updated_by': authController.userGuId.value,
    };
    for (LessonContent content in currentLessonContent) {
      arrangeData["content[${content.contentId}]"] =
          "${currentLessonContent.indexOf(content) + 1}";
    }
    String endpoint =
        "/lesson/content/arrange/${lessonsController.currentLessonGuid}";
    var res = await BaseClient()
        .formPost(
          endpoint,
          arrangeData,
        )
        .catchError(
          handleError,
        );
    if (res == null) return;
    Map data = json.decode(
      res,
    );
    if (!data['success']) {
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

  Future fetchLessonSection() async {
    if (currentLessonGuid.isNotEmpty) {
      if (isDebug) {
        print(currentLessonGuid.value);
      }
      var res = await BaseClient()
          .get(
            "/lesson/sections/$currentLessonGuid",
          )
          .catchError(
            handleError,
          );
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        List<LessonSection> lessonSections = List<LessonSection>.from(
          data['payload'].map(
            (x) => LessonSection.fromJson(
              x,
            ),
          ),
        );
        currentLessonSections.assignAll(lessonSections);
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
      update();
    }
  }

  void updateContentStatus(String contentGuid, String status) async {
    String endpoint = "/lesson/content/status/$contentGuid";
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
    if (data['success']) {
      if (data['message'] == 'STATUS_UPDATED') {
        updateStatus(contentGuid, status);
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

  void deleteLessonContent(String contentGuid) async {
    var res = await BaseClient()
        .delete(
          "/lesson/content/delete/$contentGuid",
        )
        .catchError(
          handleError,
        );
    if (res == null) return;
    Map data = json.decode(
      res,
    );
    if (data['success'] == true) {
      deleteLessonFromList(
        contentGuid,
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
