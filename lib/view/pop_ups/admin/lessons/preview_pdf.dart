import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';
import 'package:cosmic_assessments/models/lessons/lesson_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AdminPreviewPdf extends StatefulWidget {
  static String routeName = "/a/lesson/content/:content_guid";
  static String routePath = "/a/lesson/content";
  final String title;

  const AdminPreviewPdf({super.key, required this.title});

  @override
  State<AdminPreviewPdf> createState() => _AdminPreviewPdfState();
}

class _AdminPreviewPdfState extends State<AdminPreviewPdf> {
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
      body: SfPdfViewer.network(
        "$baseUrl//lesson/content/get_file?file_hash=${currentContent.fileHash!}",
      ),
    );
  }
}
