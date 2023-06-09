import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/utils/get_file_type.dart';
import 'package:cosmic_assessments/common/utils/strip_html_tags.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_section_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/models/lessons/lesson_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/delete_lesson_content_confirm.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/preview_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/preview_pdf.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/preview_video.dart';

class AdminViewSectionScreen extends StatefulWidget {
  static String routeName = "/a/section/:section_guid";
  static String routePath = "/a/section";
  final String title;
  const AdminViewSectionScreen({super.key, required this.title});
  @override
  State<AdminViewSectionScreen> createState() => _AdminViewSectionScreenState();
}

class _AdminViewSectionScreenState extends State<AdminViewSectionScreen> {
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.find<AdminLessonsController>();
  final lessonContentController = Get.put(AdminLessonContentController());
  final lessonSectionController = Get.find<AdminLessonSectionController>();
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lessonContentController.currentSectionGuid(
      lessonSectionController.currentSection.id,
    );
    lessonContentController.fetchContent();
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
                case "ADD_CONTENT":
                  Get.to(
                    () => const AdminAddLessonContentPopup(
                      title: 'Add Content',
                    ),
                    routeName: AdminAddLessonContentPopup.routeName,
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
                value: "ADD_CONTENT",
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
                      "Add Content",
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
          if (lessonContentController.isLoading.value == true) {
            return const Loader();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: GetBuilder<AdminLessonContentController>(
                    builder: (controller) {
                      List<LessonContent> lessonContents =
                          controller.currentLessonContent;
                      if (lessonContents.isEmpty) {
                        return const Center(
                          child: Text('No Content Found'),
                        );
                      }
                      return ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          controller.reorderLessonContent(
                            oldIndex,
                            newIndex,
                          );
                        },
                        scrollDirection: Axis.vertical,
                        children: lessonContents.map((lessonContent) {
                          int index = lessonContents.indexOf(lessonContent);
                          String content = stripHtmlTags(
                            lessonContent.content,
                          );
                          return Padding(
                            key: PageStorageKey<int>(index),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Transform(
                                      transform:
                                          Matrix4.translationValues(-16, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Text(
                                          //   "Id: ${lessonContent.contentId}",
                                          //   // "Id: ${\lessonContent.contentId}, Pos: ${lessonContent.position}",
                                          // ),
                                          Icon(
                                            lessonContent.type == 'html'
                                                ? Icons.abc
                                                : lessonContent.type == 'link'
                                                    ? Icons.link
                                                    : Icons.attachment,
                                          ),
                                          if (lessonContent.type == 'html')
                                            Text(
                                              content.length > 80
                                                  ? content.substring(0, 80)
                                                  : content,
                                            ),
                                          if (lessonContent.type == 'link')
                                            HtmlWidget(
                                              '<a href="$content">$content</a>',
                                            ),
                                          if (lessonContent.type == 'file')
                                            Text(
                                              '${getFileType(lessonContent.fileHash!)} Attachment',
                                            ),
                                        ],
                                      ),
                                    ),
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.menu,
                                          color: Colors.grey.shade400,
                                        ),
                                        if (lessonContent.status == '0')
                                          const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        if (lessonContent.status == '1')
                                          const Icon(
                                            Icons.check,
                                            color: Colors.greenAccent,
                                          ),
                                        if (lessonContent.status == '2')
                                          const Icon(
                                            Icons.archive,
                                            color: Colors.purple,
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
                                          case 'EDIT_CONTENT':
                                            lessonContentController
                                                .currentContentGuid(
                                              lessonContent.contentId,
                                            );
                                            lessonContentController
                                                .currentContent = lessonContent;
                                            Get.to(
                                              () =>
                                                  const AdminEditLessonContentPopup(
                                                title: 'Edit Content',
                                              ),
                                              routeName:
                                                  "${AdminEditLessonContentPopup.routePath}/${lessonContent.contentId}",
                                              fullscreenDialog: true,
                                            );
                                            break;
                                          case 'PREVIEW_CONTENT':
                                            lessonContentController
                                                .currentContentGuid(
                                              lessonContent.contentId,
                                            );
                                            lessonContentController
                                                .currentContent = lessonContent;
                                            if (lessonContent.type == 'file' &&
                                                getFileType(lessonContent
                                                        .fileHash!) ==
                                                    'PDF') {
                                              Get.to(
                                                () => const AdminPreviewPdf(
                                                  title: 'Preview Content',
                                                ),
                                                routeName:
                                                    "${AdminPreviewPdf.routePath}/${lessonContent.contentId}",
                                                fullscreenDialog: true,
                                              );
                                            } else if (lessonContent.type ==
                                                    'file' &&
                                                getFileType(lessonContent
                                                        .fileHash!) ==
                                                    'Video') {
                                              Get.to(
                                                () => AdminPreviewVideo(
                                                  fileHash:
                                                      lessonContent.fileHash!,
                                                  videoUrl:
                                                      "$baseUrl/lesson/content/get_file?file_hash=${lessonContent.fileHash!}",
                                                ),
                                                routeName:
                                                    "${AdminPreviewVideo.routePath}/${lessonContent.contentId}",
                                                fullscreenDialog: true,
                                              );
                                            } else {
                                              Get.to(
                                                () => const AdminPreviewContent(
                                                  title: 'Preview Content',
                                                ),
                                                routeName:
                                                    "${AdminPreviewContent.routePath}/${lessonContent.contentId}",
                                                fullscreenDialog: true,
                                              );
                                            }
                                            break;
                                          case 'PUBLISH_CONTENT':
                                            controller.updateContentStatus(
                                              lessonContent.contentId,
                                              '1',
                                            );
                                            break;
                                          case 'UN_PUBLISH_CONTENT':
                                            controller.updateContentStatus(
                                              lessonContent.contentId,
                                              '0',
                                            );
                                            break;
                                          case 'ARCHIVE_CONTENT':
                                            controller.updateContentStatus(
                                              lessonContent.contentId,
                                              '2',
                                            );
                                            break;
                                          case 'DELETE_CONTENT':
                                            Get.dialog(
                                              DeleteLessonContentConfirm(
                                                contentGuid:
                                                    lessonContent.contentId,
                                              ),
                                            );
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: "EDIT_CONTENT",
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
                                        if (lessonContent.type != 'link')
                                          PopupMenuItem(
                                            value: "PREVIEW_CONTENT",
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.visibility,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Preview",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (lessonContent.status == '0' ||
                                            lessonContent.status == '2')
                                          PopupMenuItem(
                                            value: "PUBLISH_CONTENT",
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
                                        if (lessonContent.status == '1' ||
                                            lessonContent.status == '2')
                                          PopupMenuItem(
                                            value: "UN_PUBLISH_CONTENT",
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
                                        if (lessonContent.status == '0' ||
                                            lessonContent.status == '1')
                                          PopupMenuItem(
                                            value: "ARCHIVE_CONTENT",
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
                                          value: "DELETE_CONTENT",
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
                        }).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
