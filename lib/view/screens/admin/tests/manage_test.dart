import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_question.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/bulk_upload_questions.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/delete_test_confirm.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/edit_test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/enrollments.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/questions.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/start_test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_run.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_settings.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_submissions.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminManageTest extends StatefulWidget {
  static String routeName = "/a/test/manage/:guid";
  static String routePath = "/a/test/manage";
  final String title;
  const AdminManageTest({super.key, required this.title});

  @override
  State<AdminManageTest> createState() => _AdminManageTestState();
}

class _AdminManageTestState extends State<AdminManageTest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final testsController = Get.find<TestsController>();
  final testController = Get.put(AdminTestController());
  final String? guid = Get.parameters['guid'];

  @override
  void initState() {
    testController.currentTestGuid(guid);
    testController.fetchTest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(testController.currentTest);
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            testsController.clearSearch();
            testsController.clearFilters();
            testsController.fetchTests();
            Get.back();
          },
        ),
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      drawer: AdminSidebar(),
      body: Obx(
        () {
          if (testController.isLoading.value == true) {
            return const Loader();
          } else {
            Test test = testController.currentTest;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Heading3(text: test.title),
                      ],
                    ),
                    spaceV20,
                    spaceV5,
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 30.0,
                          height: 75,
                          color: secondary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Heading1(
                                text:
                                    "${test.stats != null ? test.stats!.questions * int.parse(test.settings.marksPerQuestion) : "0"}",
                                color: white,
                              ),
                              spaceV5,
                              const Body2(
                                text: 'Test Marks',
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
                          width: MediaQuery.of(context).size.width / 2 - 30.0,
                          height: 75,
                          color: b2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Heading1(
                                text:
                                    "${test.stats != null ? test.stats!.submissions : '0'}",
                                color: white,
                              ),
                              spaceV5,
                              const Body2(
                                text: 'Submissions',
                                color: white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spaceV20,
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 30.0,
                          height: 75,
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Heading1(
                                text:
                                    "${test.stats != null ? test.stats!.attempts : '0'}",
                                color: white,
                              ),
                              spaceV5,
                              const Body2(
                                text: 'Attempts',
                                color: white,
                              ),
                            ],
                          ),
                        ),
                        spaceH20,
                        InkWell(
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Get.to(
                              () => const AdminTestSettings(
                                title: 'Test Settings',
                              ),
                              routeName: "${AdminTestSettings.routePath}/$guid",
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            width: MediaQuery.of(context).size.width / 2 - 30.0,
                            height: 75,
                            color: b1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.settings,
                                  size: 36,
                                  color: white,
                                ),
                                spaceV5,
                                Body2(
                                  text: 'Test Settings',
                                  color: white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    spaceV20,
                    spaceV5,
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                            child: Row(
                              children: const [
                                Heading3(text: 'Questions'),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.to(
                              () => const AdminAddQuestionPopUp(
                                title: 'Add New Question',
                              ),
                              routeName: AdminAddQuestionPopUp.routeName,
                              fullscreenDialog: true,
                            ),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.add_circle,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Add Question',
                              color: text2,
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.toNamed(
                              "${AdminTestQuestionsScreen.routePath}/$guid",
                            ),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.list_alt_outlined,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'All Questions',
                              color: text2,
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.toNamed(
                              AdminBulkUploadQuestions.routeName,
                            ),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.sim_card_download,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Import Questions',
                              color: text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (test.type == 'evaluated') spaceV15,
                    if (test.type == 'evaluated')
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        color: Colors.white,
                        elevation: 0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 15),
                              child: Row(
                                children: const [
                                  Heading3(text: 'Enrollments'),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () => Get.toNamed(
                                "${AdminEnrollments.routePath}/$guid",
                              ),
                              minLeadingWidth: 0,
                              leading: const Icon(
                                Icons.assignment_ind_outlined,
                                color: text2,
                              ),
                              title: const Body1(
                                text: 'All Enrollments',
                                color: text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    spaceV15,
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                            child: Row(
                              children: const [
                                Heading3(text: 'Submissions'),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.toNamed(
                                "${AdminTestSubmissionsScreen.routePath}/$guid"),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.check_circle,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Submission Report',
                              color: text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceV15,
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                            child: Row(
                              children: const [
                                Heading3(text: 'Setting'),
                              ],
                            ),
                          ),
                          if (test.status != '2' && test.status == '0')
                            ListTile(
                              onTap: () =>
                                  testController.doPublishUnPublishTest('1'),
                              minLeadingWidth: 0,
                              leading: const Icon(
                                Icons.toggle_on,
                                color: text2,
                              ),
                              title: const Body1(
                                text: 'Publish',
                                color: text2,
                              ),
                            ),
                          if (test.status != '2' && test.status == '1')
                            ListTile(
                              onTap: () =>
                                  testController.doPublishUnPublishTest('0'),
                              minLeadingWidth: 0,
                              leading: const Icon(
                                Icons.toggle_off,
                                color: text2,
                              ),
                              title: const Body1(
                                text: 'Un-Publish',
                                color: text2,
                              ),
                            ),
                          ListTile(
                            onTap: () => Get.toNamed(
                              "${AdminTestRunScreen.routePath}/$guid",
                            ),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.visibility,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Preview Test',
                              color: text2,
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.toNamed(
                              "${AdminStartTestScreen.routePath}/$guid",
                            ),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.rule_outlined,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Take Test',
                              color: text2,
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.to(
                              () => const AdminEditTestPopUp(
                                title: 'Edit Test',
                              ),
                              routeName:
                                  "${AdminEditTestPopUp.routePath}/$guid",
                              fullscreenDialog: true,
                            ),
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.edit_square,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Edit',
                              color: text2,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Get.dialog(
                                const DeleteTestConfirm(),
                              );
                            },
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.delete_forever,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Delete',
                              color: text2,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(
                                () => const AdminTestSettings(
                                  title: 'Test Settings',
                                ),
                                routeName:
                                    "${AdminTestSettings.routePath}/$guid",
                              );
                            },
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.settings,
                              color: text2,
                            ),
                            title: const Body1(
                              text: 'Test Settings',
                              color: text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceV15,
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
