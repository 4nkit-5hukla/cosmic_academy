import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/utils/get_file_type.dart';
import 'package:cosmic_assessments/common/widgets/memory/image.dart';
import 'package:cosmic_assessments/common/widgets/memory/txt.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/models/lessons/lesson_content.dart';

class AdminPreviewContent extends StatefulWidget {
  static String routeName = "/a/lesson/content/:content_guid";
  static String routePath = "/a/lesson/content";
  final String title;

  const AdminPreviewContent({super.key, required this.title});

  @override
  State<AdminPreviewContent> createState() => _AdminPreviewContentState();
}

class _AdminPreviewContentState extends State<AdminPreviewContent> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.find<AdminLessonsController>();
  final lessonContentController = Get.find<AdminLessonContentController>();

  late LessonContent currentContent;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentContent = lessonContentController.currentContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(
              10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
                if (currentContent.type == 'html')
                  HtmlWidget(
                    currentContent.content,
                  ),
                if (currentContent.type == 'file' &&
                    getFileType(currentContent.fileHash!) == 'Image')
                  MemImage(
                    fileHash: currentContent.fileHash!,
                  ),
                if (currentContent.type == 'file' &&
                    getFileType(currentContent.fileHash!) == 'Plain Text')
                  MemTxt(
                    fileHash: currentContent.fileHash!,
                  ),
              ],
            )),
      ),
    );
  }
}
