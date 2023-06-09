import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_enrollment_controller.dart';
import 'package:cosmic_assessments/models/tests/enrolled.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_enrollment.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/unenroll_confirm.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:intl/intl.dart';

class AdminEnrollments extends StatefulWidget {
  static String routeName = "/a/test/enrollments/:guid";
  static String routePath = "/a/test/enrollments";
  final String title;
  const AdminEnrollments({super.key, required this.title});

  @override
  State<AdminEnrollments> createState() => _AdminEnrollmentsState();
}

class _AdminEnrollmentsState extends State<AdminEnrollments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final testController = Get.find<AdminTestController>();
  final testEnrollmentController = Get.put(AdminTestEnrollMentController());

  final String? guid = Get.parameters['guid'];

  @override
  void initState() {
    testEnrollmentController
        .currentTestGuid(testController.currentTestGuid.value);
    testEnrollmentController.getEnrolledUsers();
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
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
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
          if (testEnrollmentController.isLoading.value == true) {
            return const Loader();
          } else {
            return Column(
              children: [
                if (testEnrollmentController.enrolledUsers.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      controller: testEnrollmentController.scrollController,
                      itemCount: testEnrollmentController.enrolledUsers.length,
                      itemBuilder: (context, index) {
                        Enrolled enrolledUser =
                            testEnrollmentController.enrolledUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        children: [
                                          Heading3(
                                            text:
                                                "${enrolledUser.firstName} ${enrolledUser.lastName}",
                                            color: text1,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // TextButton(
                                          //   onPressed: () {},
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.min,
                                          //     children: const [
                                          //       Icon(
                                          //         Icons.edit,
                                          //         size: 18,
                                          //         color: text2,
                                          //       ),
                                          //       spaceH5,
                                          //       Body1(
                                          //         text: 'Edit',
                                          //         color: text2,
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // spaceH5,
                                          TextButton(
                                            onPressed: () {
                                              Get.dialog(
                                                UnEnrollConfirm(
                                                  userGuid: enrolledUser.guid,
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(
                                                  Icons.close_rounded,
                                                  size: 18,
                                                  color: text2,
                                                ),
                                                spaceH5,
                                                Body1(
                                                  text: 'UnEnroll',
                                                  color: text2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  spaceV10,
                                  Row(
                                    children: [
                                      const Body2(
                                        text: "Student ID:",
                                        bold: true,
                                      ),
                                      spaceH5,
                                      Body2(
                                        text: enrolledUser.guid,
                                      ),
                                    ],
                                  ),
                                  spaceV10,
                                  Row(
                                    children: [
                                      const Body2(
                                        text: "Start Date/Time:",
                                        bold: true,
                                      ),
                                      spaceH5,
                                      Body2(
                                        text: DateFormat('dd/MM/yyyy HH:mm a')
                                            .format(enrolledUser.startDate),
                                      ),
                                    ],
                                  ),
                                  spaceV10,
                                  Row(
                                    children: [
                                      const Body2(
                                        text: "End Date/Time:",
                                        bold: true,
                                      ),
                                      spaceH5,
                                      Body2(
                                        text: DateFormat('dd/MM/yyyy HH:mm a')
                                            .format(enrolledUser.endDate),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (testEnrollmentController.enrolledUsers.isEmpty)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.find_in_page,
                            size: 100,
                            // color: grey,
                          ),
                          Container(height: 15),
                          const Text(
                            "Enrollments Not Found.",
                            style: TextStyle(
                              // color: grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                spaceV20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Get.to(
                              () => const AdminAddEnrolmentPopUp(
                                title: 'Add Enrollment',
                              ),
                              routeName: AdminAddEnrolmentPopUp.routeName,
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.person_add_alt_1_outlined),
                              spaceH5,
                              Body1(
                                text: 'Add New Enrollment',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spaceV30,
              ],
            );
          }
        },
      ),
    );
  }
}
