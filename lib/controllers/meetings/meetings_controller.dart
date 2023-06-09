import 'dart:convert';

import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/meetings/meeting.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class MeetingsController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  RxInt firstPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt totalResults = 0.obs;
  RxString numResults = '15'.obs;
  RxBool isLoading = false.obs;
  RxBool isNextLoading = false.obs;
  RxString search = ''.obs;
  RxString orderBy = 'newest_first'.obs;
  List<Meeting> meetingsList = List<Meeting>.empty(growable: true).obs;
  List<Meeting> usersMeetingsList = List<Meeting>.empty(growable: true).obs;
  late Meeting currentMeeting;
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

  final Map messages = {
    'MEETINGS_FOUND': 'Meetings Found.',
    'MEETING_FOUND': 'Meeting Found.',
    'MEETING_NOT_FOUND': 'Meeting Not Found.',
    'MEETING_DELETED_SUCCESSFULLY': 'Meeting Deleted Successfully.',
    'MEETING_SHARED': 'Meeting Shred to the selected users.',
  };

  List<Meeting> getFilteredMeetings(String term) {
    return meetingsList
        .where((element) =>
            element.details.toLowerCase().contains(term.toLowerCase()))
        .toList();
  }

  void clearFilters() {
    numResults(
      '15',
    );
    orderBy(
      'newest_first',
    );
  }

  void clearSearch() => search(
        '',
      );

  Future fetchMeetings() async {
    isLoading(true);
    currentPage(1);
    var res = await BaseClient().formPost("/zoom/list", {
      if (numResults.value != '15') 'results_per_page': numResults.value,
      'page': currentPage.value.toString(),
      if (orderBy.value != '') 'order_by': orderBy.value,
      if (search.value != '') 'search': search.value,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    firstPage(data['payload']['meta']['first_page']);
    lastPage(data['payload']['meta']['last_page']);
    currentPage(data['payload']['meta']['current_page']);
    totalResults(data['payload']['meta']['total_results']);
    List<Meeting> meetings = meetingFromJson(
      json.encode(data['payload']['data']),
    );
    meetingsList.assignAll(meetings);
    isLoading(false);
  }

  Future fetchUsersMeetings(String userGuid) async {
    isLoading(true);
    currentPage(1);
    var res = await BaseClient()
        .get("/zoom/get_meetings/$userGuid")
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Meeting> meetings = meetingFromJson(
      json.encode(data['payload']),
    );
    usersMeetingsList.assignAll(meetings);
    isLoading(false);
  }

  paginateMeetings() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage.value < lastPage.value) {
          currentPage(currentPage.value + 1);
          fetchMoreMeetings(currentPage);
        }
      }
    });
  }

  void fetchMoreMeetings(RxInt page) async {
    isNextLoading(true);
    var res = await BaseClient().formPost("/zoom/list", {
      'results_per_page': numResults.value,
      'page': currentPage.value.toString(),
      'order_by': orderBy.value,
      'search': search.value,
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<Meeting> meetings = meetingFromJson(
      data['payload']['data'],
    );
    meetingsList.addAll(meetings);
    isNextLoading(false);
    // update();
  }

  Future deleteMeeting(String meetingGuid) async {
    var res = await BaseClient()
        .delete("/zoom/delete/$meetingGuid")
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success']) {
      Get.snackbar(
        "Success",
        messages[data['message']],
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: globalController.mainColor,
        colorText: white,
      );
    } else {
      Get.snackbar(
        "Error",
        messages[data['message']] ?? "Something Went Wrong",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: secondary,
        colorText: white,
      );
    }
    isLoading(false);
    update();
    fetchMeetings();
  }

  Future shareMeeting(
      String meetingGuid, Map<String, String> selectedUsers) async {
    isLoading(true);
    String endpoint = "/zoom/share/$meetingGuid";
    var res = await BaseClient()
        .formPost(endpoint, selectedUsers)
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      if (data['message'] == 'MEETING_SHARED') {
        fetchMeetings().then((value) {
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
        });
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
