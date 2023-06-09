import 'dart:convert';

import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/models/tests/enrolled_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class StudentTestsController extends GetxController with BaseController {
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
  RxString testType = 'evaluated'.obs;
  RxString status = '1'.obs;
  List<Test> testsList = List<Test>.empty(growable: true).obs;
  List<EnrolledTest> enrolledTestsList =
      List<EnrolledTest>.empty(growable: true).obs;
  late Test? currentTest = null.obs as Test?;
  final authController = Get.find<AuthController>();
  ScrollController scrollController = ScrollController();
  Map<String, String> notFound = {
    "evaluated": "No Evaluated Tests Found",
    "practice": "No Practice Tests Found",
    "quiz": "No Quizzes Found",
  };

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
  String getOrderLabel(String value) {
    return orderByOptions.firstWhere((element) => element.value == value).label;
  }

  final List<FilterOption> statusOptions = [
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

  void clearFilters() {
    numResults('15');
    orderBy('newest_first');
    role('all');
    status('1');
  }

  void clearSearch() {
    search('');
  }

  List<EnrolledTest> getEnrolledTestsByListing(String listing) {
    DateTime now = DateTime.now();
    if (listing == 'upcoming') {
      return enrolledTestsList
          .where((test) => test.startDate.isAfter(now))
          .toList();
    } else if (listing == 'ongoing') {
      return enrolledTestsList
          .where((test) =>
              test.startDate.isBefore(now) && test.endDate.isAfter(now))
          .toList();
    } else if (listing == 'previous') {
      return enrolledTestsList
          .where((test) => test.endDate.isBefore(now))
          .toList();
    } else {
      // Return all tests by default
      return enrolledTestsList;
    }
  }

  void fetchTests() async {
    if (testType.value == 'evaluated') {
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/tests/my_enrolments/${authController.userGuId.value}",
          )
          .catchError(handleError);
      Map data = json.decode(res);
      enrolledTestsList.assignAll(
        enrolledTestFromJson(
          json.encode(
            data['payload'],
          ),
        ),
      );
      isLoading(false);
    } else {
      isLoading(true);
      currentPage(1);
      var res = await BaseClient().formPost("/tests/list", {
        'results_per_page': numResults.value,
        'page': currentPage.value.toString(),
        'order_by': orderBy.value,
        'status': status.value,
        'test_type': testType.value,
        'search': search.value,
      }).catchError(handleError);
      Map data = json.decode(res);
      List<Test> tests = List<Test>.from(
        data['payload']['data'].map(
          (x) => Test.fromMap(
            x,
          ),
        ),
      );
      firstPage(data['payload']['meta']['first_page']);
      lastPage(data['payload']['meta']['last_page']);
      currentPage(data['payload']['meta']['current_page']);
      totalResults(data['payload']['meta']['total_results']);
      testsList.assignAll(tests);
      isLoading(false);
    }

    // update();
  }

  paginateTests() {
    if (!scrollController.hasClients) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (currentPage.value < lastPage.value) {
            currentPage(currentPage.value + 1);
            fetchMoreTests(currentPage);
          }
        }
      });
    }
  }

  void fetchMoreTests(RxInt page) async {
    isNextLoading(true);
    print("fetching page $page");
    var res = await BaseClient().formPost("/tests/list", {
      'results_per_page': numResults.value,
      'page': currentPage.value.toString(),
      'order_by': orderBy.value,
      'status': status.value,
      'search': search.value,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Test> tests = List<Test>.from(
      data['payload']['data'].map(
        (x) => Test.fromMap(
          x,
        ),
      ),
    );
    testsList.addAll(tests);
    isNextLoading(false);
    // update();
  }
}
