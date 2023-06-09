import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_report_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_submissions_controller.dart';
import 'package:cosmic_assessments/models/submissions/submission.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_report.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminTestSubmissionsScreen extends StatefulWidget {
  static String routeName = "/a/test/submissions/:guid";
  static String routePath = "/a/test/submissions";
  final String title;

  const AdminTestSubmissionsScreen({super.key, required this.title});

  @override
  State<AdminTestSubmissionsScreen> createState() =>
      _AdminTestSubmissionsScreenState();
}

class _AdminTestSubmissionsScreenState
    extends State<AdminTestSubmissionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final testController = Get.find<AdminTestController>();
  final testSubmissionsController = Get.put(AdminTestSubmissionsController());
  final testReportController = Get.put(AdminTestReportController());

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'N/A';
    }
    return DateFormat('d MMM, yy, HH:mm:ss').format(date);
  }

  @override
  void initState() {
    testSubmissionsController
        .currentTestGuid(testController.currentTestGuid.value);
    testReportController.currentTestGuid(testController.currentTestGuid.value);
    testSubmissionsController.fetchTestSubmissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (testSubmissionsController.currentUserGuid.value != '') {
          testSubmissionsController.currentUserGuid('');
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: grey,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            widget.title,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
        drawer: AdminSidebar(),
        body: Obx(
          () {
            if (testSubmissionsController.isLoading.value == true) {
              return const Loader();
            } else {
              if (testSubmissionsController.testSubmissions.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GetBuilder<AdminTestSubmissionsController>(
                        builder: (controller) {
                          List<Submission> testSubmissions =
                              controller.testSubmissions;
                          return ListView.builder(
                            itemCount: testSubmissions.length,
                            itemBuilder: (context, index) {
                              Submission submission = testSubmissions[index];
                              String userGuid = submission.guid;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        onTap: () {
                                          testReportController.currentUserGuid(
                                            submission.guid,
                                          );
                                          testReportController.fetchTestReport(
                                            submission.sessionId,
                                          );
                                          Get.toNamed(
                                            "${AdminTestReportScreen.routePath}/${testController.currentTestGuid.value}",
                                          );
                                        },
                                        minVerticalPadding: 15,
                                        title: Text(
                                          "${(index + 1)}: ${submission.firstName} ${submission.lastName}",
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'User Id:- $userGuid',
                                            ),
                                            Text(
                                              'Last Attempted on:- ${DateFormat(
                                                'd MMM, yy',
                                              ).format(
                                                submission.startTime,
                                              )}.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'No Submissions found.',
                    style: TextStyle(fontSize: 25),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
