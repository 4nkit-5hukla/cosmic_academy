import 'package:cosmic_assessments/common/utils/pluralize.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_report_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_submissions_controller.dart';
import 'package:cosmic_assessments/models/submissions/submission.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_report.dart';
import 'package:cosmic_assessments/view/sidebar/student/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentTestSubmissionsScreen extends StatefulWidget {
  static String routeName = "/test/submissions/:guid";
  static String routePath = "/test/submissions";
  final String title;

  const StudentTestSubmissionsScreen({super.key, required this.title});

  @override
  State<StudentTestSubmissionsScreen> createState() =>
      _StudentTestSubmissionsScreenState();
}

class _StudentTestSubmissionsScreenState
    extends State<StudentTestSubmissionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<StudentTestController>();
  final testSubmissionsController = Get.put(StudentTestSubmissionsController());
  final testReportController = Get.put(StudentTestReportController());

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'N/A';
    }
    return DateFormat('d MMM, yy, HH:mm:ss').format(date);
  }

  @override
  void initState() {
    String userGuId = authController.userGuId.value;
    testSubmissionsController
        .currentTestGuid(testController.currentTestGuid.value);
    testReportController.currentTestGuid(testController.currentTestGuid.value);
    testSubmissionsController.currentUserGuid(userGuId);
    testSubmissionsController.fetchTestSubmissions();
    print(testController.currentTestGuid.value);
    // TODO: implement initState
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
        drawer: StudentSidebar(),
        body: Obx(
          () {
            if (testSubmissionsController.isLoading.value == true) {
              return const Loader();
            } else {
              if (testSubmissionsController.testSubmissions.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Text(
                        'Your Submissions: ${pluralize(testSubmissionsController.getTotalSubmissions(), 'time')}',
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<StudentTestSubmissionsController>(
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
                                            "${StudentTestReportScreen.routePath}/${testController.currentTestGuid.value}",
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
