import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/models/courses/course.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/courses/delete_course_confirm.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/courses/edit_course.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_question.dart';
import 'package:cosmic_assessments/view/screens/admin/lessons/lessons.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_submissions.dart';

class AdminManageCourse extends StatefulWidget {
  static String routeName = "/a/course/manage/:guid";
  static String routePath = "/a/course/manage";
  final String title;
  const AdminManageCourse({
    super.key,
    required this.title,
  });

  @override
  State<AdminManageCourse> createState() => _AdminManageCourseState();
}

class _AdminManageCourseState extends State<AdminManageCourse> {
  final courseController = Get.put(
    AdminCourseController(),
  );
  final String? guid = Get.parameters['guid'];

  @override
  void initState() {
    courseController.currentCourseGuid(
      guid,
    );
    courseController.fetchCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(testController.currentTest);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Obx(
        () {
          if (courseController.isLoading.value == true) {
            return const Loader();
          } else {
            Course course = courseController.currentCourse;
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
                        horizontal: 20,
                        vertical: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Title: ${course.title}",
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
                          if (course.description != '')
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
                                  course.description,
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (course.description == '')
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
                      horizontal: 15,
                      vertical: 10,
                    ),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(width: 6),
                              const Text(
                                "Lessons",
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          onTap: () => Get.toNamed(
                            AdminAddLessonPopup.routeName,
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.add,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Add Lessons',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed(
                            AdminLessonsScreen.routeName,
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.playlist_play,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'All Lessons',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.toNamed(
                            "${AdminTestSubmissionsScreen.routePath}/$guid",
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.list_alt,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Organize Lessons',
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
                      horizontal: 15,
                      vertical: 10,
                    ),
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
                                "Tests",
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
                          onTap: null,
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.question_mark,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Add Tests',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.to(
                            () => const AdminAddQuestionPopUp(
                              title: 'Add New Question',
                            ),
                            routeName: AdminAddQuestionPopUp.routeName,
                            fullscreenDialog: true,
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.list_alt,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Organize Tests',
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
                      horizontal: 15,
                      vertical: 10,
                    ),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(width: 6),
                              const Text(
                                "Status",
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (course.status != '2' && course.status == '0')
                          ListTile(
                            onTap: () =>
                                courseController.doPublishUnPublishCourse('1'),
                            minLeadingWidth: 0,
                            leading: Icon(
                              Icons.publish,
                              color: Colors.grey.shade800,
                            ),
                            title: const Text(
                              'Publish',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        if (course.status == '2' || course.status == '1')
                          ListTile(
                            onTap: () =>
                                courseController.doPublishUnPublishCourse('0'),
                            minLeadingWidth: 0,
                            leading: Icon(
                              Icons.download,
                              color: Colors.grey.shade800,
                            ),
                            title: Text(
                              course.status == '1'
                                  ? 'Un-Publish'
                                  : 'Un-Archive',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        if (course.status != '2')
                          ListTile(
                            onTap: () {
                              courseController.doPublishUnPublishCourse('2');
                            },
                            minLeadingWidth: 0,
                            leading: Icon(
                              Icons.archive,
                              color: Colors.grey.shade800,
                            ),
                            title: const Text(
                              'Archive',
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
                      horizontal: 15,
                      vertical: 10,
                    ),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(width: 6),
                              const Text(
                                "Settings",
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
                          onTap: () => Get.to(
                            () => const AdminEditCoursePopUp(
                              title: 'Edit Course',
                            ),
                            routeName:
                                "${AdminEditCoursePopUp.routePath}/$guid",
                            fullscreenDialog: true,
                          ),
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.edit,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Edit Course',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Get.dialog(
                              const DeleteCourseConfirm(),
                            );
                          },
                          minLeadingWidth: 0,
                          leading: Icon(
                            Icons.delete_forever,
                            color: Colors.grey.shade800,
                          ),
                          title: const Text(
                            'Scrap Course',
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
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
