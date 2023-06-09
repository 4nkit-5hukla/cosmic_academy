import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cosmic_assessments/common/widgets/courses/admin_course_filter_dialog.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/models/lessons/lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/delete_lesson_confirm.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson.dart';
import 'package:cosmic_assessments/view/screens/admin/lessons/view_lesson.dart';

class AdminLessonsScreen extends StatefulWidget {
  static String routeName = "/a/lessons";
  final String title;
  const AdminLessonsScreen({super.key, required this.title});
  @override
  State<AdminLessonsScreen> createState() => _AdminLessonsScreenState();
}

class _AdminLessonsScreenState extends State<AdminLessonsScreen> {
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.put(AdminLessonsController());
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            showSearch ? Colors.white : Theme.of(context).primaryColor,
        leading: showSearch
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(
                    () => {
                      showSearch = false,
                    },
                  );
                  if (searchController.text != '') {
                    searchController.text = "";
                    lessonsController.clearSearch();
                    lessonsController.clearFilters();
                    lessonsController.fetchLessons();
                  }
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
        title: showSearch
            ? TextField(
                maxLines: 1,
                controller: searchController,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (term) {
                  if (searchController.text != '') {
                    lessonsController.search(searchController.text);
                    lessonsController.fetchLessons();
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              )
            : Text(
                widget.title,
              ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: showSearch ? Colors.black : Colors.white,
            ),
            onPressed: () => setState(
              () => {
                showSearch = true,
              },
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: showSearch ? Colors.black : Colors.white,
            ),
            onSelected: (String value) {
              if (value == 'ADD_NEW_LESSON') {
                Get.to(
                  () => const AdminAddLessonPopup(
                    title: 'Add New Lesson',
                  ),
                  routeName: AdminAddLessonPopup.routeName,
                  fullscreenDialog: true,
                );
              } else if (value == 'SHOW_FILTER') {
                Get.dialog(
                  AdminCourseFilterDialog(),
                );
              }
            },
            itemBuilder: (context) => [
              showSearch
                  ? PopupMenuItem(
                      value: "SHOW_FILTER",
                      child: Row(
                        children: const [
                          Icon(
                            Icons.sort_outlined,
                            color: Colors.black,
                          ),
                          Text(
                            "Filters",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : PopupMenuItem(
                      value: "ADD_NEW_LESSON",
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          Text(
                            "New Lesson",
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
          if (lessonsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (lessonsController.lessonsList.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GetBuilder<AdminLessonsController>(
                      builder: (controller) {
                        return ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.lessonsList.length,
                          itemBuilder: (context, index) {
                            Lesson lesson = controller.lessonsList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Chip(
                                                label: Text(
                                                  lesson.guid,
                                                ),
                                              ),
                                              Text(
                                                DateFormat(
                                                  'EEEE, MMM d, yyyy',
                                                ).format(
                                                  lesson.createdOn,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            lesson.title,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                        ),
                                        iconSize: 30,
                                        onSelected: (String value) {
                                          switch (value) {
                                            case 'CONTENT':
                                              controller.currentLessonGuid(
                                                lesson.guid,
                                              );
                                              Get.to(
                                                () =>
                                                    const AdminAddLessonContentPopup(
                                                  title: 'Add Content',
                                                ),
                                                routeName:
                                                    AdminAddLessonContentPopup
                                                        .routeName,
                                                fullscreenDialog: true,
                                              );
                                              break;
                                            case 'EDIT_LESSON':
                                              controller.currentLessonGuid(
                                                lesson.guid,
                                              );
                                              Get.to(
                                                () =>
                                                    const AdminEditLessonPopUp(
                                                  title: 'Edit Lesson',
                                                ),
                                                routeName:
                                                    "${AdminEditLessonPopUp.routePath}/${lesson.guid}",
                                                fullscreenDialog: true,
                                              );
                                              break;
                                            case 'VIEW_LESSON':
                                              controller.currentLessonGuid(
                                                lesson.guid,
                                              );
                                              Get.to(
                                                () => AdminViewLessonScreen(
                                                  title: lesson.title,
                                                ),
                                                routeName:
                                                    "${AdminViewLessonScreen.routePath}/${lesson.guid}",
                                              );
                                              break;
                                            case 'PUBLISH_LESSON':
                                              controller.updateLessonStatus(
                                                lesson.guid,
                                                '1',
                                              );
                                              break;
                                            case 'UN_PUBLISH_LESSON':
                                              controller.updateLessonStatus(
                                                lesson.guid,
                                                '0',
                                              );
                                              break;
                                            case 'ARCHIVE_LESSON':
                                              controller.updateLessonStatus(
                                                lesson.guid,
                                                '2',
                                              );
                                              break;
                                            case 'DELETE_LESSON':
                                              Get.dialog(
                                                DeleteLessonConfirm(
                                                  lessonGuid: lesson.guid,
                                                ),
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
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: "VIEW_LESSON",
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.book,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "View",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (lesson.status == '0' ||
                                              lesson.status == '2')
                                            PopupMenuItem(
                                              value: "PUBLISH_LESSON",
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.publish,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Publish",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (lesson.status == '1' ||
                                              lesson.status == '2')
                                            PopupMenuItem(
                                              value: "UN_PUBLISH_LESSON",
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.unarchive,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Un-Publish",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (lesson.status == '0' ||
                                              lesson.status == '1')
                                            PopupMenuItem(
                                              value: "ARCHIVE_LESSON",
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.archive,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Archive",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          PopupMenuItem(
                                            value: "DELETE_LESSON",
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.delete_forever,
                                                  size: 30,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
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
                  ),
                  if (lessonsController.isNextLoading.value == true)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.find_in_page,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    Container(height: 15),
                    Text(
                      "No Lessons found.",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
