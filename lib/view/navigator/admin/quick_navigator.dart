import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';

class QuickNavigatorAdmin extends StatefulWidget {
  final BottomNavigationController bottomNavigationController;

  const QuickNavigatorAdmin({
    Key? key,
    required this.bottomNavigationController,
  }) : super(key: key);

  @override
  State<QuickNavigatorAdmin> createState() => _QuickNavigatorAdminState();
}

class _QuickNavigatorAdminState extends State<QuickNavigatorAdmin> {
  final testsController = Get.find<TestsController>();
  final meetingsController = Get.find<MeetingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ClipRRect(
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
                testsController.fetchTests();
              } else {
                testsController.testsList.clear();
              }
              if (index == 2) {
                meetingsController.fetchMeetings();
                meetingsController.paginateMeetings();
              } else {
                meetingsController.meetingsList.clear();
              }
            },
            currentIndex: widget.bottomNavigationController.selectedIndex.value,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.house_outlined,
                  size: 32,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    Img.get(
                      'course.svg',
                    ),
                    color:
                        widget.bottomNavigationController.selectedIndex.value ==
                                1
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
              //     Icons.person_4_outlined,
              //     size: 32,
              //   ),
              //   label: "Account",
              // ),
            ],
          ),
        ));
  }
}
