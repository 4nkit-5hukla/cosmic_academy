// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';

class DeleteLessonContentConfirm extends StatefulWidget {
  final String contentGuid;

  const DeleteLessonContentConfirm({
    Key? key,
    required this.contentGuid,
  }) : super(key: key);

  @override
  State<DeleteLessonContentConfirm> createState() =>
      _DeleteLessonContentConfirmState();
}

class _DeleteLessonContentConfirmState
    extends State<DeleteLessonContentConfirm> {
  final lessonContentController = Get.find<AdminLessonContentController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please Confirm',
              style: Get.textTheme.headline4,
            ),
            Text(
              "Are you sure you want to delete this content?",
              style: Get.textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) {
                      lessonContentController
                          .deleteLessonContent(widget.contentGuid);
                      Get.back();
                    }
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) Get.back();
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
