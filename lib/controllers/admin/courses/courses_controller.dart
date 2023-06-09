import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/courses/course.dart';

import 'package:cosmic_assessments/services/base_client.dart';

class CoursesController extends GetxController with BaseController {
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
  List<Course> coursesList = List<Course>.empty(growable: true).obs;
  late Course? currentCourse = null.obs as Course?;
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

    // For fetchCourses
    fetchCourses();

    // For Pagination
    paginateCourses();
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

  void fetchCourses() async {
    isLoading(true);
    currentPage(1);
    var res = await BaseClient().formPost("/course/list", {
      if (numResults.value != '15') 'records_per_page': numResults.value,
      'page': currentPage.value.toString(),
      if (orderBy.value != '') 'order_by': orderBy.value,
      if (status.value != '') 'status': status.value,
      if (search.value != '') 'search': search.value,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Course> courses = List<Course>.from(
      data['payload']['data'].map(
        (x) => Course.fromMap(
          x,
        ),
      ),
    );
    firstPage(data['payload']['meta']['first_page']);
    lastPage(data['payload']['meta']['last_page']);
    currentPage(data['payload']['meta']['current_page']);
    totalResults(data['payload']['meta']['total_results']);
    coursesList.assignAll(courses);
    isLoading(false);
  }

  paginateCourses() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage.value < lastPage.value) {
          currentPage(currentPage.value + 1);
          fetchMoreCourses(currentPage);
        }
      }
    });
  }

  void fetchMoreCourses(RxInt page) async {
    isNextLoading(true);
    print("fetching page $page");
    var res = await BaseClient().formPost("/course/list", {
      if (numResults.value != '15') 'records_per_page': numResults.value,
      'page': currentPage.value.toString(),
      if (orderBy.value != '') 'order_by': orderBy.value,
      if (status.value != '') 'status': status.value,
      if (search.value != '') 'search': search.value,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Course> courses = List<Course>.from(
      data['payload']['data'].map(
        (x) => Course.fromMap(
          x,
        ),
      ),
    );
    coursesList.addAll(courses);
    isNextLoading(false);
  }
}
