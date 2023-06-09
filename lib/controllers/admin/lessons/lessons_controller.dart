import 'dart:convert';

import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/courses/course.dart';
import 'package:cosmic_assessments/models/lessons/lesson.dart';

import 'package:cosmic_assessments/services/base_client.dart';

class AdminLessonsController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  RxInt firstPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt totalResults = 0.obs;
  RxString numResults = '15'.obs;
  RxBool isLoading = false.obs;
  RxBool isNextLoading = false.obs;
  RxString search = ''.obs;
  RxString orderBy = 'newest_first'.obs;
  RxString role = 'all'.obs;
  RxString status = ''.obs;
  RxString currentLessonGuid = ''.obs;
  RxString currentContentGuid = ''.obs;
  List<Lesson> lessonsList = List<Lesson>.empty(growable: true).obs;
  late Lesson currentLesson;
  Lesson getCurrentLesson(String lessonGuid) => lessonsList.firstWhere(
        (lesson) => lessonGuid == lesson.guid,
      );

  void deleteLessonFromList(String lessonGuid) {
    lessonsList.removeWhere(
      (lesson) => lessonGuid == lesson.guid,
    );
  }

  void updateLesson(String lessonGuid, String status) {
    int index = lessonsList.indexWhere((lesson) => lessonGuid == lesson.guid);
    lessonsList.assignAll(
      List.from(
        lessonsList.map(
          (lesson) {
            if (lessonsList.indexOf(lesson) == index) {
              Lesson newLesson = lesson;
              newLesson.status = status;
              return newLesson;
            } else {
              return lesson;
            }
          },
        ),
      ),
    );
  }

  final Map messages = {
    'LESSON_DELETED_SUCCESSFULLY': 'Lesson Deleted Successfully.',
    'STATUS_UPDATED': 'Lesson Updated.',
  };

  ScrollController scrollController = ScrollController();

  final List<FilterOption> perPageOptions = [
    FilterOption(
      value: '15',
      label: '15 at a Time',
    ),
    FilterOption(
      value: '30',
      label: '30 at a Time',
    ),
    FilterOption(
      value: '50',
      label: '50 at a Time',
    ),
    FilterOption(
      value: '100',
      label: '100 at a Time',
    ),
  ];
  final List<FilterOption> orderByOptions = [
    FilterOption(
      value: 'newest_first',
      label: 'Newest First',
    ),
    FilterOption(
      value: 'newest_last',
      label: 'Newest Last',
    ),
    FilterOption(
      value: 'title_asc',
      label: 'Title Asc',
    ),
    FilterOption(
      value: 'title_desc',
      label: 'Title Desc',
    ),
  ];
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
    return statusOptions.firstWhere((element) => element.value == status).label;
  }

  @override
  void onInit() {
    super.onInit();

    // For fetchLessons
    fetchLessons();

    // For Pagination
    paginateLessons();
  }

  void clearFilters() {
    numResults('15');
    orderBy('newest_first');
    role('all');
    status('');
  }

  void clearSearch() {
    search('');
  }

  void fetchLessons() async {
    isLoading(true);
    currentPage(1);
    String currentCourseGuid = courseController.currentCourseGuid.value;
    var res = await BaseClient().formPost("/lesson/list", {
      if (numResults.value != '15') 'records_per_page': numResults.value,
      'page': currentPage.value.toString(),
      if (orderBy.value != '') 'order_by': orderBy.value,
      if (status.value != '') 'status': status.value,
      if (search.value != '') 'search': search.value,
      'course_guid': currentCourseGuid,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Lesson> lessons = List<Lesson>.from(
      data['payload']['data'].map(
        (x) => Lesson.fromJson(
          x,
        ),
      ),
    );
    firstPage(data['payload']['meta']['first_page']);
    lastPage(data['payload']['meta']['last_page']);
    currentPage(data['payload']['meta']['current_page']);
    totalResults(data['payload']['meta']['total_results']);
    lessonsList.assignAll(lessons);
    isLoading(false);
  }

  paginateLessons() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage.value < lastPage.value) {
          currentPage(currentPage.value + 1);
          fetchMoreLessons(currentPage);
        }
      }
    });
  }

  void fetchMoreLessons(RxInt page) async {
    isNextLoading(true);
    print("fetching page $page");
    var res = await BaseClient().formPost("/lesson/list", {
      if (numResults.value != '15') 'records_per_page': numResults.value,
      'page': currentPage.value.toString(),
      if (orderBy.value != '') 'order_by': orderBy.value,
      if (status.value != '') 'status': status.value,
      if (search.value != '') 'search': search.value,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Lesson> lessons = List<Lesson>.from(
      data['payload']['data'].map(
        (x) => Course.fromMap(
          x,
        ),
      ),
    );
    lessonsList.addAll(lessons);
    isNextLoading(false);
  }

  void updateLessonStatus(String lessonGuid, String status) async {
    isLoading(true);
    String endpoint = "/lesson/status/$lessonGuid";
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
        updateLesson(lessonGuid, status);
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

  void deleteLesson(
    String lessonGuid,
  ) async {
    isLoading(true);
    var res = await BaseClient()
        .delete(
          "/lesson/delete/$lessonGuid",
        )
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true) {
      deleteLessonFromList(lessonGuid);
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
