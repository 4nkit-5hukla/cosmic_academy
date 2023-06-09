import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/tests_controller.dart';
import 'package:cosmic_assessments/view/screens/student/meetings.dart';
import 'package:cosmic_assessments/view/screens/student/tests/tests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/view/sidebar/student/sidebar.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/view/navigator/student/quick_navigator.dart';

class StudentHomeScreen extends StatefulWidget {
  static String routeName = "/home";
  final String title;
  const StudentHomeScreen({super.key, required this.title});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final authController = Get.find<AuthController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final testsController = Get.find<StudentTestsController>();
  final meetingsController = Get.find<MeetingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: spaceZero,
        leadingWidth: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: white,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          )
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              spaceV20,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Body2(
                      text: 'Welcome',
                    ),
                    Heading1(
                      text: authController.getUserFullName(),
                    ),
                  ],
                ),
              ),
              spaceV20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      meetingsController
                          .fetchUsersMeetings(authController.userGuId.value);
                      Get.to(
                        () => const StudentMeetingsList(
                          title: 'Online Classes',
                          useBack: true,
                        ),
                        routeName: StudentMeetingsList.routeName,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 30.0,
                      height: 100,
                      color: secondary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Heading2(
                            text: 'Online Classes',
                            textAlign: TextAlign.center,
                            color: white,
                            bold: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceH20,
                  InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      testsController.testType("evaluated");
                      testsController.fetchTests();
                      Get.to(
                        () => const StudentBrowseTests(
                          title: 'Evaluated Tests',
                          useBack: true,
                        ),
                        routeName: StudentBrowseTests.routeName,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 30.0,
                      height: 100,
                      color: b2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Heading2(
                            text: "Evaluated Tests",
                            textAlign: TextAlign.center,
                            color: white,
                            bold: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              spaceV20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      testsController.testType("practice");
                      testsController.fetchTests();
                      Get.to(
                        () => const StudentBrowseTests(
                          title: 'Practice Tests',
                          useBack: true,
                        ),
                        routeName: StudentBrowseTests.routeName,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 30.0,
                      height: 100,
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Heading2(
                            text: "Practice Tests",
                            textAlign: TextAlign.center,
                            color: white,
                            bold: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceH20,
                  InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      testsController.testType("quiz");
                      testsController.fetchTests();
                      Get.to(
                        () => const StudentBrowseTests(
                          title: 'Quizzes',
                          useBack: true,
                        ),
                        routeName: StudentBrowseTests.routeName,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 30.0,
                      height: 100,
                      color: b1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Heading2(
                            text: 'Quizzes',
                            textAlign: TextAlign.center,
                            color: white,
                            bold: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      drawer: StudentSidebar(),
      bottomNavigationBar: QuickNavigatorStudent(
        bottomNavigationController: bottomNavigationController,
      ),
    );
  }
}
