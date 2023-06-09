import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/tests_controller.dart';

class QuickNavigatorStudent extends StatefulWidget {
  const QuickNavigatorStudent({
    Key? key,
    required this.bottomNavigationController,
  }) : super(key: key);

  final BottomNavigationController bottomNavigationController;

  @override
  State<QuickNavigatorStudent> createState() => _QuickNavigatorStudentState();
}

class _QuickNavigatorStudentState extends State<QuickNavigatorStudent> {
  final testsController = Get.find<StudentTestsController>();
  final meetingsController = Get.find<MeetingsController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: onyx,
          selectedItemColor: white,
          unselectedItemColor: text2,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            widget.bottomNavigationController.changeIndex(index);
            if (index == 1) {
              testsController.testType('evaluated');
              testsController.fetchTests();
            } else {
              testsController.testsList.clear();
              testsController.enrolledTestsList.clear();
            }
            if (index == 2) {
              meetingsController
                  .fetchUsersMeetings(authController.userGuId.value);
            }
          },
          currentIndex: widget.bottomNavigationController.selectedIndex.value,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  Img.get('course.svg'),
                  color:
                      widget.bottomNavigationController.selectedIndex.value == 1
                          ? white
                          : text2,
                ),
              ),
              label: "Tests",
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.video_chat,
                size: 32,
              ),
              label: "Classes",
            ),
            // const BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.person,
            //     size: 32,
            //   ),
            //   label: "Account",
            // )
          ],
        ),
      ),
    );
  }
}
