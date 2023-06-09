import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/admin_settings.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/courses.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/meetings.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';
import 'package:cosmic_assessments/view/screens/admin/users/users.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';
import 'package:cosmic_assessments/view/screens/my_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AdminSidebar extends StatelessWidget {
  AdminSidebar({Key? key}) : super(key: key);
  final storage = const FlutterSecureStorage();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final List<dynamic> drawerMenuListName = [
      // {
      //   "leading": null,
      //   "title": "Main",
      //   "trailing": null,
      //   "action_id": "title",
      // },
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
          Icons.settings_suggest_outlined,
          color: globalController.contrastColor,
        ),
        "title": "Settings",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 100,
      },
      // {
      //   "leading": Icon(
      //     Icons.dashboard,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "Dashboard",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": -3,
      // },
      // {
      //   "leading": Icon(
      //     Icons.notifications,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "Notifications",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": -2,
      // },
      // {
      //   "leading": Icon(
      //     Icons.chat_rounded,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "Chat",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": -1,
      // },
      // {
      //   "leading": null,
      //   "title": "Store Data",
      //   "trailing": null,
      //   "action_id": "title",
      // },
      // {
      //   "leading": Icon(
      //     Icons.person,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "My Profile",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": 0,
      // },
      {
        "leading": Icon(
          Icons.people,
          color: globalController.contrastColor,
        ),
        "title": "Users",
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
        "title": "Tests",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 2,
      },
      {
        "leading": Icon(
          Icons.video_chat,
          color: globalController.contrastColor,
        ),
        "title": "Classes",
        "trailing": Icon(
          Icons.chevron_right,
          color: globalController.contrastColor,
        ),
        "action_id": 4,
      },
      // {
      //   "leading": Icon(
      //     Icons.book_online,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "Courses",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": 3,
      // },
      // {
      //   "leading": null,
      //   "title": "Other",
      //   "trailing": null,
      //   "action_id": "title",
      // },
      // {
      //   "leading": Icon(
      //     Icons.security,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "Security",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": 4,
      // },
      // {
      //   "leading": Icon(
      //     Icons.account_circle_rounded,
      //     color: globalController.contrastColor,
      //   ),
      //   "title": "Profile",
      //   "trailing": Icon(
      //     Icons.chevron_right,
      //     color: globalController.contrastColor,
      //   ),
      //   "action_id": 5,
      // },
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
                          color: contrastColor.withOpacity(0.25),
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
                  color: globalController.contrastColor,
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
                          color: globalController.contrastColor,
                        )
                      : Heading4(
                          text: sideMenuData['title'],
                          color: globalController.contrastColor,
                          fontWeight: FontWeight.w300,
                        ),
                  trailing: sideMenuData['trailing'],
                  onTap: () async {
                    Get.back();
                    switch (sideMenuData['action_id']) {
                      case 1:
                        Get.toNamed(
                          AdminUsersScreen.routeName,
                        );
                        break;
                      case 2:
                        Get.toNamed(
                          AdminTestsScreen.routeName,
                        );
                        break;
                      case 100:
                        Get.toNamed(
                          AdminSettings.routeName,
                        );
                        break;
                      case 4:
                        Get.toNamed(
                          AdminMeetingsList.routeName,
                        );
                        break;
                      case 5:
                        Get.toNamed(
                          MyAccount.routeName,
                        );
                        break;
                      case 3:
                        Get.to(
                          () => const AdminCoursesScreen(
                            title: 'Courses',
                          ),
                          routeName: AdminCoursesScreen.routeName,
                          fullscreenDialog: true,
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
