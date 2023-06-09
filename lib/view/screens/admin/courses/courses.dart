import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cosmic_assessments/common/widgets/courses/admin_course_filter_dialog.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/admin/courses/courses_controller.dart';
import 'package:cosmic_assessments/models/courses/course.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/courses/add_course.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/manage_course.dart';

class AdminCoursesScreen extends StatefulWidget {
  static String routeName = "/a/courses";
  final String title;
  const AdminCoursesScreen({super.key, required this.title});
  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen> {
  final coursesController = Get.put(CoursesController());
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
                    coursesController.clearSearch();
                    coursesController.clearFilters();
                    coursesController.fetchCourses();
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
                    coursesController.search(searchController.text);
                    coursesController.fetchCourses();
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
              if (value == 'ADD_NEW_COURSE') {
                Get.to(
                  () => const AdminAddCoursePopUp(
                    title: 'Add New Course',
                  ),
                  routeName: AdminAddCoursePopUp.routeName,
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
                      value: "ADD_NEW_COURSE",
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          Text(
                            "New Course",
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
          if (coursesController.isLoading.value == true) {
            return const Loader();
          } else {
            if (coursesController.coursesList.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GetBuilder<CoursesController>(
                      builder: (controller) {
                        return ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.coursesList.length,
                          itemBuilder: (context, index) {
                            Course course = controller.coursesList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Get.toNamed(
                                          "${AdminManageCourse.routePath}/${course.guid}",
                                        );
                                      },
                                      leading: Chip(
                                        label: Text(
                                          course.guid,
                                        ),
                                      ),
                                      title: Text(
                                        course.title,
                                      ),
                                      subtitle: Text(
                                        'Created On:- ${DateFormat(
                                          'EEEE, MMM d, yyyy',
                                        ).format(
                                          course.createdOn,
                                        )}',
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
                  if (coursesController.isNextLoading.value == true)
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
                      "No Courses found.",
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
