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
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class AdminLessonContentController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.find<AdminLessonsController>();
  final Map messages = {
    'CONTENT_ADDED': 'Content Added Successfully.',
    'LESSON_NOT_FOUND': 'Lesson Not Found.',
    'CONTENT_DELETED_SUCCESSFULLY': 'Content Deleted Successfully.',
    'CONTENT_CREATED_SUCCESSFULLY': 'Content Added Successfully.',
    'CONTENT_UPDATED_SUCCESSFULLY': 'Lesson Updated Successfully.',
    'CONTENT_UPDATED': 'Lesson Updated Successfully.',
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
  RxBool loadingQuestions = false.obs;
  RxString currentLessonGuid = "".obs;
  RxString currentSectionGuid = "".obs;
  RxString currentContentGuid = "".obs;
  RxInt attemptId = 0.obs;
  RxInt questionIndex = 0.obs;
  late Lesson currentLesson;
  List<LessonContent> currentLessonContent =
      List<LessonContent>.empty(growable: true).obs;
  late LessonContent currentContent;
  List<Question> testQuestions = List<Question>.empty(growable: true).obs;
  ScrollController scrollController = ScrollController();
  String getStatusLabel(String status) {
    return statusOptions
        .firstWhere(
          (element) => element.value == status,
        )
        .label;
  }

  void reorderLessonContent(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final LessonContent oldLessonContent =
        currentLessonContent.removeAt(oldIndex);
    currentLessonContent.insert(newIndex, oldLessonContent);
    update();
    arrangeContent();
  }

  void deleteLessonFromList(String contentGuid) {
    currentLessonContent.removeWhere(
      (content) => contentGuid == content.contentId,
    );
  }

  Future fetchContent() async {
    if (currentSectionGuid.isNotEmpty) {
      print(currentSectionGuid.value);
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/lesson/content/list/$currentSectionGuid",
          )
          .catchError(
            handleError,
          );
      isLoading(false);
      update();
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        List<LessonContent> lessonContent = List<LessonContent>.from(
          data['payload'].map(
            (x) => LessonContent.fromJson(
              x,
            ),
          ),
        );
        lessonContent.sort(
            (a, b) => int.parse(a.position).compareTo(int.parse(b.position)));
        currentLessonContent.assignAll(lessonContent);
      } else {
        currentLessonContent.clear();
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
    String endpoint = "/lesson/content/upload/${currentSectionGuid.value}";
    var res = await BaseClient()
        .formPost(
          endpoint,
          {
            'created_by': authController.userGuId.value,
            'section_id': currentSectionGuid.value
          },
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

  Future replaceFile(String fieldName, String filePath, String fileHash,
      String userGuid) async {
    String endpoint = "/lesson/content/upload/${currentSectionGuid.value}";
    var res = await BaseClient()
        .formPost(
          endpoint,
          {
            'file_hash': fileHash,
            'created_by': userGuid,
            'section_id': currentSectionGuid.value
          },
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

  void getFileType() {}

  void getFileData() {}

  void addUpdateContent(
    dynamic contentData, [
    bool updateContent = false,
  ]) async {
    isLoading(true);
    String endpoint = !updateContent
        ? "/lesson/content/add/${currentSectionGuid.value}"
        : "/lesson/content/edit/${currentSectionGuid.value}";
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
      if (data['message'] == 'CONTENT_ADDED') {
        fetchContent();
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
    String endpoint = "/lesson/content/arrange/${currentSectionGuid.value}";
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

  Future fetchLessonContent() async {
    if (currentContentGuid.isNotEmpty) {
      if (isDebug) {
        print(currentContentGuid.value);
      }
      var res = await BaseClient()
          .get(
            "/lesson/content/view/$currentContentGuid",
          )
          .catchError(
            handleError,
          );
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        currentContent = LessonContent.fromJson(
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
