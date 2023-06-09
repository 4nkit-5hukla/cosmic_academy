// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';

class DeleteLessonConfirm extends StatefulWidget {
  final String lessonGuid;

  const DeleteLessonConfirm({
    Key? key,
    required this.lessonGuid,
  }) : super(key: key);

  @override
  State<DeleteLessonConfirm> createState() => _DeleteLessonConfirmState();
}

class _DeleteLessonConfirmState extends State<DeleteLessonConfirm> {
  final lessonController = Get.find<AdminLessonsController>();
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
              "Are you sure you want to delete this lesson?",
              style: Get.textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) {
                      lessonController.deleteLesson(widget.lessonGuid);
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
