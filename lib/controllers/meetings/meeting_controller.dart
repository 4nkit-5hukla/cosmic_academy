import 'dart:convert';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/services/base_client.dart';
import 'package:cosmic_assessments/models/meetings/meeting.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';

class MeetingController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final meetingsController = Get.find<MeetingsController>();

  RxBool isLoading = false.obs;
  RxBool loadingQuestions = false.obs;
  RxString testSessionId = "".obs;
  RxString currentMeetingGuid = "".obs;
  RxInt attemptId = 0.obs;
  RxInt questionIndex = 0.obs;
  late Meeting currentMeeting;
  List<String> currentMeetingUsers = [];

  final Map messages = {
    'MEETING_FOUND': 'Meeting Found.',
    'MEETING_NOT_FOUND': 'Meeting Not Found.',
    'MEETING_DELETED_SUCCESSFULLY': 'Meeting Deleted Successfully.',
    'MEETING_CREATED_SUCCESSFULLY': 'Meeting Created Successfully.',
    'MEETING_UPDATED_SUCCESSFULLY': 'Meeting Updated Successfully.',
  };

  void fetchMeeting() async {
    if (currentMeetingGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/zoom/view/$currentMeetingGuid",
          )
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        currentMeeting = Meeting.fromJson(data['payload']);
        print(currentMeeting);
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

  Future fetchMeetingUsers() async {
    if (currentMeetingGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get(
            "/zoom/get_users/$currentMeetingGuid",
          )
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        List<dynamic> usersList = data['payload'].map((user) {
          return user["guid"];
        }).toList();
        currentMeetingUsers = usersList.map((item) => item.toString()).toList();
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

  Future addUpdateMeeting(dynamic meetingData) async {
    isLoading(true);
    String endpoint = currentMeetingGuid.value == ""
        ? "/zoom/create"
        : "/zoom/create/$currentMeetingGuid";
    var res = await BaseClient()
        .formPost(endpoint, meetingData)
        .catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success']) {
      if (data['message'] == 'MEETING_CREATED_SUCCESSFULLY' ||
          data['message'] == 'MEETING_UPDATED_SUCCESSFULLY') {
        meetingsController.fetchMeetings().then((value) {
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
