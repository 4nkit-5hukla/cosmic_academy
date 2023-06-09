import 'dart:convert';

import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/submissions/attempt.dart';
import 'package:cosmic_assessments/models/submissions/submission.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class StudentTestSubmissionsController extends GetxController
    with BaseController {
  RxBool isLoading = false.obs;
  RxBool loadingSubmissions = false.obs;
  RxString currentTestGuid = "".obs;
  RxString currentUserGuid = "".obs;
  RxString currentUser = "".obs;
  RxString currentAttempt = "".obs;
  RxString currentSessionId = "".obs;
  List<Submission> testSubmissions = List<Submission>.empty(growable: true).obs;
  List<Attempt> testAttempts = List<Attempt>.empty(growable: true).obs;
  late List<dynamic> testAnswers = List.empty(growable: true).obs;
  final Map messages = {};

  int getTotalSubmissions() => testSubmissions.length;

  int getTotalAttempts() => testAttempts.length;

  void fetchTestSubmissions() async {
    if (currentTestGuid.isNotEmpty && currentUserGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient().formPost(
        "/tests/submissions",
        {
          'test_guid': currentTestGuid.value,
          'user_guid': currentUserGuid.value,
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
}
