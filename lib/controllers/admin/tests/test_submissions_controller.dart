import 'dart:convert';

import 'package:cosmic_assessments/models/reports/report.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/submissions/attempt.dart';
import 'package:cosmic_assessments/models/submissions/submission.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class AdminTestSubmissionsController extends GetxController
    with BaseController {
  RxBool isLoading = false.obs;
  RxBool hasReport = false.obs;
  RxBool loadingSubmissions = false.obs;
  RxString currentTestGuid = "".obs;
  RxString currentUserGuid = "".obs;
  RxString currentUser = "".obs;
  RxString currentAttempt = "".obs;
  RxString currentSessionId = "".obs;
  List<Submission> testSubmissions = List<Submission>.empty(growable: true).obs;
  List<Attempt> testAttempts = List<Attempt>.empty(growable: true).obs;
  late List<dynamic> testAnswers = List.empty(growable: true).obs;
  late Report currentReport;
  final Map messages = {};

  int getTotalSubmissions() => testSubmissions.length;

  int getTotalAttempts() => testAttempts.length;

  void fetchTestSubmissions() async {
    if (currentTestGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient().formPost(
        "/tests/submissions",
        {
          'test_guid': currentTestGuid.value,
        },
      ).catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      List<Submission> submissions = List<Submission>.from(
        data['payload'].map(
          (x) => Submission.fromMap(
            x,
          ),
        ),
      );
      testSubmissions.assignAll(submissions);
      isLoading(false);
    }
  }

  void fetchTestAttempts() async {
    if (currentTestGuid.isNotEmpty && currentUserGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient().formPost(
        "/tests/submissions/$currentTestGuid",
        {
          'user_guid': currentUserGuid.value,
        },
      ).catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      List<Attempt> attempts = List<Attempt>.from(
        data['payload'].map(
          (x) => Attempt.fromMap(
            x,
          ),
        ),
      );
      testAttempts.assignAll(attempts);
      isLoading(false);
    }
  }
}
