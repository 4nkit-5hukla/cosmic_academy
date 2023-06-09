import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/admin_settings.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/meetings.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';
import 'package:cosmic_assessments/view/screens/admin/users/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/view/navigator/admin/quick_navigator.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';

class AdminHomeScreen extends StatefulWidget {
  final String title;

  const AdminHomeScreen({
    super.key,
    required this.title,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final authController = Get.find<AuthController>();
  final testsController = Get.find<TestsController>();
  final meetingsController = Get.find<MeetingsController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();

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
                      testsController.fetchTests();
                      Get.toNamed(
                        AdminTestsScreen.routeName,
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
                        children: [
                          SvgPicture.asset(
                            Img.get(
                              'course.svg',
                            ),
                            color: white,
                            width: 24,
                          ),
                          spaceV10,
                          const Heading2(
                            text: 'Tests',
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
                      Get.toNamed(
                        AdminUsersScreen.routeName,
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
                          Icon(
                            Icons.groups_2_outlined,
                            size: 36,
                            color: white,
                          ),
                          spaceV5,
                          Heading2(
                            text: "Users",
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
                      meetingsController.fetchMeetings().then((value) {
                        meetingsController.paginateMeetings();
                      });
                      Get.toNamed(
                        AdminMeetingsList.routeName,
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
                          Icon(
                            Icons.video_chat,
                            size: 36,
                            color: white,
                          ),
                          spaceV5,
                          Heading2(
                            text: 'Classes',
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
                      Get.toNamed(
                        AdminSettings.routeName,
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
                          Icon(
                            Icons.settings,
                            color: white,
                          ),
                          spaceV10,
                          Heading2(
                            text: 'Settings',
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
      drawer: AdminSidebar(),
      bottomNavigationBar: QuickNavigatorAdmin(
        bottomNavigationController: bottomNavigationController,
      ),
    );
  }
}
