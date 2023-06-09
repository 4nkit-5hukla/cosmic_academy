import 'dart:convert';

import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/reports/report.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class StudentTestReportController extends GetxController with BaseController {
  RxBool isLoading = false.obs;
  RxBool hasReport = false.obs;
  RxString currentTestGuid = "".obs;
  RxString currentUserGuid = "".obs;
  RxString currentTestSession = "".obs;
  late Report currentReport;
  final Map messages = {};

  void fetchTestReport(String sessionId) async {
    isLoading(true);
    var res = await BaseClient().formPost(
      "/tests/report/$currentTestGuid",
      {
        'user_guid': currentUserGuid.value,
        'session_id': sessionId,
      },
    ).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data["message"] == "REPORT_FOUND") {
      hasReport(true);
      currentReport = Report.fromMap(
        data['payload'],
      );
    }
    isLoading(false);
  }
}
