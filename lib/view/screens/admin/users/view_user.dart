import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/users/users_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/admin/users/user_controller.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/users/edit_user.dart';

class AdminViewUser extends StatefulWidget {
  static String routeName = "/a/view-user/:guid";
  static String routePath = "/a/view-user";
  final String title;
  const AdminViewUser({super.key, required this.title});

  @override
  State<AdminViewUser> createState() => _AdminViewUserState();
}

class _AdminViewUserState extends State<AdminViewUser> {
  final globalController = Get.find<GlobalController>();
  final usersController = Get.find<UsersController>();
  final userController = Get.put(UserController());
  final String? guid = Get.parameters['guid'];

  @override
  void initState() {
    userController.currentUserGuid(guid);
    userController.fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.to(
                () => const AdminEditUserPopup(
                  title: 'Edit User',
                ),
                routeName: "${AdminEditUserPopup.routePath}/$guid",
                fullscreenDialog: true,
              );
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: const Text(
              'Edit User',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value == true) {
          return const Loader();
        } else {
          Map<String, dynamic> user = userController.currentUser.toMap();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'User Detail',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        String message = await userController.activateUser();
                        if (message.isNotEmpty) {
                          bool msgCondition = message.contains('Wrong');
                          Get.snackbar(
                            !msgCondition ? "Success" : "Error",
                            message,
                            icon: const Icon(
                              Icons.check,
                              color: white,
                            ),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: !msgCondition
                                ? globalController.mainColor
                                : Colors.red,
                            colorText: white,
                          );
                          usersController.fetchUsers().then(
                                (value) => usersController.paginateUsers(),
                              );
                        }
                      },
                      child: const Body1(
                        text: 'Activate',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        String message = await userController.archiveUser();
                        if (message.isNotEmpty) {
                          bool msgCondition = message.contains('Wrong');
                          Get.snackbar(
                            !msgCondition ? "Success" : "Error",
                            message,
                            icon: const Icon(
                              Icons.check,
                              color: white,
                            ),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: !msgCondition
                                ? globalController.mainColor
                                : Colors.red,
                            colorText: white,
                          );
                          usersController.fetchUsers().then(
                                (value) => usersController.paginateUsers(),
                              );
                        }
                      },
                      child: const Body1(
                        text: 'Archive',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        String message = await userController.deactivateUser();
                        if (message.isNotEmpty) {
                          bool msgCondition = message.contains('Wrong');
                          Get.snackbar(
                            !msgCondition ? "Success" : "Error",
                            message,
                            icon: const Icon(
                              Icons.check,
                              color: white,
                            ),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: !msgCondition
                                ? globalController.mainColor
                                : Colors.red,
                            colorText: white,
                          );
                          usersController.fetchUsers().then(
                                (value) => usersController.paginateUsers(),
                              );
                        }
                      },
                      child: const Body1(
                        text: 'Deactivate',
                      ),
                    ),
                  ],
                ),
                ...user.entries.map((entry) {
                  return Text(
                    "${entry.key}: ${entry.value}",
                  );
                }).toList()
              ],
              // [
              //   const Text('User Detail'),
              //   Text(
              //     "userId: ${userController.currentUser.guid}",
              //   ),
              //   Text(
              //     "First Name: ${userController.currentUser.firstName}",
              //   ),
              //   Text(
              //     "Middle Name: ${userController.currentUser.middleName}",
              //   ),
              //   Text(
              //     "Last Name: ${userController.currentUser.lastName}",
              //   ),
              //   Text(
              //     "Role: ${userController.currentUser.role}",
              //   ),
              //   Text(
              //     "userName: ${userController.currentUser.userLogin}",
              //   ),
              //   Text(
              //     "userEmail: ${userController.currentUser.userEmail}",
              //   ),
              //   Text(
              //     "userMobile: ${userController.currentUser.userMobile}",
              //   ),
              //   Text(
              //     "registeredOn: ${userController.currentUser.userRegistered}",
              //   ),
              //   Text(
              //     "userStatus: ${userController.currentUser.userStatus}",
              //   ),
              // ],
            ),
          );
        }
      }),
    );
  }
}
