import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_controller.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/view/screens/student/tests/start_test.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_submissions.dart';

class StudentTestDetails extends StatefulWidget {
  static String routeName = "/test/details/:guid";
  static String routePath = "/test/details";
  final String title;
  const StudentTestDetails({super.key, required this.title});
  @override
  State<StudentTestDetails> createState() => _StudentTestDetailsState();
}

class _StudentTestDetailsState extends State<StudentTestDetails> {
  final testController = Get.put(StudentTestController());
  final String? guid = Get.parameters['guid'];

  @override
  void initState() {
    testController.currentTestGuid(guid);
    testController.fetchTest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Obx(
        () {
          if (testController.isLoading.value == true) {
            return const Loader();
          } else {
            Test test = testController.currentTest;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        2,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Title: ${test.title}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (test.details != '')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                HtmlWidget(
                                  // """<i>hello</i>""",
                                  test.details,
                                ),
                              ],
                            ),
                          if (test.details == '')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'No Content',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: <Widget>[
                              Container(width: 6),
                              const Text(
                                "Action & Reports",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          onTap: () => Get.toNamed(
                            "${StudentStartTestScreen.routePath}/$guid",
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.playlist_play,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Start Test',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed(
                            "${StudentTestSubmissionsScreen.routePath}/$guid",
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.list_alt,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'My Attempts',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => {},
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.reviews,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Write Review',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: <Widget>[
                              Container(width: 6),
                              const Text(
                                "Reviews & Rating",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Center(
                          child: Text(
                            'Coming Soon',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
