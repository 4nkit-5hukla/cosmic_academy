import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_section_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/models/lessons/lesson.dart';
import 'package:cosmic_assessments/models/lessons/lesson_section.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson_section.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson_section.dart';
import 'package:cosmic_assessments/view/screens/admin/lessons/view_section.dart';

class AdminViewLessonScreen extends StatefulWidget {
  static String routeName = "/a/lesson/:lesson_guid";
  static String routePath = "/a/lesson";
  final String title;
  const AdminViewLessonScreen({super.key, required this.title});
  @override
  State<AdminViewLessonScreen> createState() => _AdminViewLessonScreenState();
}

class _AdminViewLessonScreenState extends State<AdminViewLessonScreen> {
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.find<AdminLessonsController>();
  final lessonController = Get.put(AdminLessonController());
  final lessonSectionController = Get.put(AdminLessonSectionController());
  final lessonContentController = Get.put(AdminLessonContentController());
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lessonController.currentLessonGuid(
      lessonsController.currentLessonGuid.value,
    );
    lessonController.fetchLesson();
    lessonSectionController.currentLessonGuid(
      lessonsController.currentLessonGuid.value,
    );
    lessonSectionController.fetchLessonSection();
    // lessonContentController.fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lesson: ${widget.title.length > 20 ? "${widget.title.substring(0, 20)}..." : widget.title}",
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: showSearch ? Colors.black : Colors.white,
            ),
            onSelected: (String value) {
              switch (value) {
                case "ADD_SECTION":
                  Get.to(
                    () => const AdminAddLessonSectionPopup(
                      title: 'Add Section',
                    ),
                    routeName: AdminAddLessonSectionPopup.routeName,
                    fullscreenDialog: true,
                  );
                  break;
                case "EDIT_LESSON":
                  Get.to(
                    () => const AdminEditLessonPopUp(
                      title: 'Edit Lesson',
                    ),
                    routeName:
                        "${AdminEditLessonPopUp.routePath}/${lessonContentController.currentLessonGuid}",
                    fullscreenDialog: true,
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "EDIT_LESSON",
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Edit Lesson",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "ADD_SECTION",
                child: Row(
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Add Section",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Obx(
        () {
          if (lessonController.isLoading.value == true ||
              lessonSectionController.isLoading.value == true) {
            return const Loader();
          } else {
            Lesson currentLesson = lessonController.currentLesson;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: white,
                    elevation: 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentLesson.description != '')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Heading3(text: 'Description'),
                                spaceV5,
                                HtmlWidget(
                                  currentLesson.description,
                                ),
                              ],
                            ),
                          if (currentLesson.description == '')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Body1(text: 'No Description', bold: true),
                                spaceV5,
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  spaceV5,
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Heading3(text: 'Lesson Section'),
                  ),
                  spaceV10,
                  GetBuilder<AdminLessonSectionController>(
                    builder: (controller) {
                      List<LessonSection> lessonSections =
                          controller.currentLessonSections;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lessonSections.length,
                        itemBuilder: (context, index) {
                          LessonSection section = lessonSections[index];
                          // String sectionId = section.id;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    minVerticalPadding: 15,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Heading4(
                                          text:
                                              "${(index + 1)}. ${section.title.replaceAll('\n', '')}",
                                        ),
                                      ],
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                      ),
                                      iconSize: 30,
                                      onSelected: (String value) {
                                        controller.currentSection = section;
                                        switch (value) {
                                          case 'EDIT_SECTION':
                                            Get.to(
                                              () =>
                                                  const AdminEditLessonSectionPopup(
                                                title: 'Edit Section',
                                              ),
                                              routeName:
                                                  "${AdminEditLessonSectionPopup.routePath}/${section.id}",
                                              fullscreenDialog: true,
                                            );
                                            break;
                                          case 'VIEW_SECTION':
                                            Get.to(
                                              () => AdminViewSectionScreen(
                                                title:
                                                    "Section: ${section.title}",
                                              ),
                                              routeName:
                                                  "${AdminViewSectionScreen.routePath}/${section.id}",
                                            );
                                            break;
                                          case 'DELETE_SECTION':
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: "EDIT_SECTION",
                                          child: MenuItem(
                                            label: 'Edit',
                                            icon: Icons.edit,
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: "VIEW_SECTION",
                                          child: MenuItem(
                                            label: 'View',
                                            icon: Icons.visibility,
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: "DELETE_SECTION",
                                          child: MenuItem(
                                            label: 'Delete',
                                            icon: Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  spaceV10,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
