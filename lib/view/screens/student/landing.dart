import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/view/screens/student/meetings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/view/screens/profile.dart';
import 'package:cosmic_assessments/view/screens/student/home.dart';
import 'package:cosmic_assessments/view/screens/student/tests/tests.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/tests_controller.dart';

class StudentLandingScreen extends StatefulWidget {
  static String routeName = "/landing";
  final String title;

  const StudentLandingScreen({super.key, required this.title});

  @override
  State<StudentLandingScreen> createState() => _StudentLandingScreenState();
}

class _StudentLandingScreenState extends State<StudentLandingScreen> {
  final bottomNavigationController = Get.put(BottomNavigationController());
  final testsController = Get.put(StudentTestsController());
  final meetingsController = Get.put(MeetingsController());
  final List<Widget> screens = [
    const StudentHomeScreen(
      title: 'Home',
    ),
    const StudentBrowseTests(
      title: 'Evaluated Tests',
      useBack: false,
    ),
    const StudentMeetingsList(
      title: 'Online Classes',
    ),
    // todo remove StudentTestReportPage later
    // const StudentTestReportPage(),
    // const CoursesScreen(
    //   title: 'Courses',
    // ),
    // const ProfileScreen(
    //   title: 'Profile',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: bottomNavigationController.selectedIndex.value,
          children: screens,
        ),
      ),
    );
  }
}
