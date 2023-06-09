import 'package:cosmic_assessments/common/utils/strip_html_tags.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_report_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_submissions_controller.dart';
import 'package:cosmic_assessments/models/reports/report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentTestReportScreen extends StatefulWidget {
  static String routeName = "/test/report/:guid";
  static String routePath = "/test/report";
  final String title;

  const StudentTestReportScreen({super.key, required this.title});

  @override
  State<StudentTestReportScreen> createState() =>
      _StudentTestReportScreenState();
}

class _StudentTestReportScreenState extends State<StudentTestReportScreen> {
  final testSubmissionsController =
      Get.find<StudentTestSubmissionsController>();
  final testController = Get.find<StudentTestController>();
  final testReportController = Get.find<StudentTestReportController>();
  String viewType = 'summary';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        testSubmissionsController.currentSessionId("");
        testReportController.currentUserGuid("");
        testReportController.currentTestSession("");
        return true;
      },
      child: Scaffold(
        backgroundColor: grey,
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
        ),
        body: Obx(
          () {
            if (testReportController.isLoading.isTrue) {
              return const Loader();
            } else {
              if (testReportController.hasReport.isTrue) {
                Report currentReport = testReportController.currentReport;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 25,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  viewType = 'summary';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: viewType == 'summary'
                                      ? secondary
                                      : Theme.of(context).primaryColor,
                                ),
                                alignment: Alignment.center,
                                child: const Body1(
                                  text: "Summary",
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          spaceH10,
                          if (currentReport.answers.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    viewType = 'details';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 35,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: viewType == 'details'
                                        ? secondary
                                        : Theme.of(context).primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Body1(
                                    text: "Details ",
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (viewType == 'summary')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              width:
                                  MediaQuery.of(context).size.width / 2 - 30.0,
                              height: 75,
                              color: secondary,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Body2(
                                    text: 'Result: ${currentReport.result}',
                                    color: white,
                                  ),
                                  spaceV5,
                                  Heading1(
                                    text:
                                        "${currentReport.marksObtained}/${int.parse(testController.currentTest.settings.marksPerQuestion) * currentReport.answers.length}",
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                            spaceH20,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              width:
                                  MediaQuery.of(context).size.width / 2 - 30.0,
                              height: 75,
                              color: b2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Body2(
                                    text: 'Correct',
                                    color: white,
                                  ),
                                  spaceV5,
                                  Heading1(
                                    text: "${currentReport.numCorrect}",
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (viewType == 'summary')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              width:
                                  MediaQuery.of(context).size.width / 2 - 30.0,
                              height: 75,
                              color: Theme.of(context).primaryColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Body2(
                                    text: 'Incorrect',
                                    color: white,
                                  ),
                                  spaceV5,
                                  Heading1(
                                    text: "${currentReport.numWrong}",
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                            spaceH20,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              width:
                                  MediaQuery.of(context).size.width / 2 - 30.0,
                              height: 75,
                              color: b1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Body2(
                                    text: 'Unanswered',
                                    color: white,
                                  ),
                                  spaceV5,
                                  Heading1(
                                    text: "${currentReport.numNotAttempted}",
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (viewType == 'details')
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            ...currentReport.answers.map((answer) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${answer.questionId}. ${stripHtmlTags(answer.question).replaceAll('&nbsp;', '')}",
                                          softWrap: true,
                                          maxLines: 20,
                                        ),
                                        spaceV5,
                                        Text(
                                          "Correct Answer: ${answer.answerKey == '' ? "None" : answer.answerKey.replaceAll('choice_', '')}",
                                        ),
                                        spaceV5,
                                        Text(
                                          "Evaluation: ${answer.response}",
                                        ),
                                        spaceV5,
                                        Text(
                                          "Marks Obtained: ${answer.marksObtained}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'No Report Found.',
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
