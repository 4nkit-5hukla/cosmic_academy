import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/meetings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/view/screens/admin/home.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';

class AdminLandingScreen extends StatefulWidget {
  static String routeName = "/a/home";
  final String title;

  const AdminLandingScreen({super.key, required this.title});

  @override
  State<AdminLandingScreen> createState() => _AdminLandingScreenState();
}

class _AdminLandingScreenState extends State<AdminLandingScreen> {
  final bottomNavigationController = Get.put(BottomNavigationController());
  final testsController = Get.put(TestsController());
  final meetingsController = Get.put(MeetingsController());
  final List<Widget> screens = [
    const AdminHomeScreen(
      title: 'Home',
    ),
    const AdminTestsScreen(
      title: 'Tests',
      useBack: false,
    ),
    const AdminMeetingsList(
      title: 'List Zoom Meeting',
      useBack: false,
    ),
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
