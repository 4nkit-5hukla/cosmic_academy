import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/tests_controller.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';
import 'package:cosmic_assessments/view/screens/my_account.dart';
import 'package:cosmic_assessments/view/screens/student/meetings.dart';
import 'package:cosmic_assessments/view/screens/student/tests/tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StudentSidebar extends StatelessWidget {
  StudentSidebar({Key? key}) : super(key: key);
  final storage = const FlutterSecureStorage();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final testsController = Get.find<StudentTestsController>();
  final meetingsController = Get.find<MeetingsController>();

  @override
  Widget build(BuildContext context) {
    final List<dynamic> drawerMenuListName = [
      {
        "leading": Icon(
          Icons.account_circle_rounded,
          color: globalController.contrastColor,
        ),
        "title": "My Account",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 5,
      },
      {
        "leading": Icon(
          Icons.video_chat,
          color: globalController.contrastColor,
        ),
        "title": "Online Classes",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 1,
      },
      {
        "leading": SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            Img.get(
              'course.svg',
            ),
            color: globalController.contrastColor,
          ),
        ),
        "title": "Evaluated Tests",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 2,
      },
      {
        "leading": SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            Img.get(
              'course.svg',
            ),
            color: globalController.contrastColor,
          ),
        ),
        "title": "Practice Tests",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 3,
      },
      {
        "leading": SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            Img.get(
              'course.svg',
            ),
            color: globalController.contrastColor,
          ),
        ),
        "title": "Quizzes",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 4,
      },
    ];
    Color avatarColor = generateAvatarColor(
        "${authController.getUserDisplayName()}-${authController.userGuId}");
    Color contrastColor = generateAvatarContrast(avatarColor);
    return SafeArea(
      child: SizedBox(
        width: 280,
        child: Drawer(
          backgroundColor: Theme.of(context).primaryColor,
          child: ListView(
            children: [
              spaceV30,
              ListTile(
                leading: InkWell(
                  onTap: () {
                    Get.toNamed(
                      MyAccount.routeName,
                    );
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: avatarColor,
                      child: Text(
                        getInitials(
                          name: authController.getUserDisplayName(),
                        ),
                        style: TextStyle(
                          color: contrastColor,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Heading4(
                  text: authController.getUserDisplayName(),
                  color: white,
                  fontWeight: FontWeight.w300,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.power_settings_new_rounded,
                    color: secondary,
                  ),
                  onPressed: () async {
                    authController.logOutUser().then((value) {
                      if (value) {
                        storage.deleteAll().then((value) {
                          globalController.token('');
                          Get.offNamed(
                            SignInScreen.routeName,
                          );
                        });
                      }
                    });
                  },
                ),
              ),
              ...drawerMenuListName.map((sideMenuData) {
                return ListTile(
                  dense: true,
                  minLeadingWidth: 0,
                  leading: sideMenuData['leading'],
                  title: sideMenuData['action_id'] == "title"
                      ? Heading3(
                          text: sideMenuData['title'],
                          color: white,
                        )
                      : Heading4(
                          text: sideMenuData['title'],
                          color: white,
                          fontWeight: FontWeight.w300,
                        ),
                  trailing: sideMenuData['trailing'],
                  onTap: () async {
                    Get.back();
                    switch (sideMenuData['action_id']) {
                      case 1:
                        meetingsController
                            .fetchUsersMeetings(authController.userGuId.value);
                        Get.to(
                          () => const StudentMeetingsList(
                            title: 'Online Classes',
                            useBack: true,
                          ),
                          routeName: StudentMeetingsList.routeName,
                        );
                        break;
                      case 2:
                        testsController.testType("evaluated");
                        testsController.fetchTests();
                        Get.to(
                          () => const StudentBrowseTests(
                            title: 'Evaluated Tests',
                            useBack: true,
                          ),
                          routeName: StudentBrowseTests.routeName,
                        );
                        break;
                      case 3:
                        testsController.testType("practice");
                        testsController.fetchTests();
                        Get.to(
                          () => const StudentBrowseTests(
                            title: 'Practice Tests',
                            useBack: true,
                          ),
                          routeName: StudentBrowseTests.routeName,
                        );
                        break;
                      case 4:
                        testsController.testType("quiz");
                        testsController.fetchTests();
                        Get.to(
                          () => const StudentBrowseTests(
                            title: 'Quizzes',
                            useBack: true,
                          ),
                          routeName: StudentBrowseTests.routeName,
                        );
                        break;
                      case 5:
                        Get.toNamed(
                          MyAccount.routeName,
                        );
                        break;
                    }
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
