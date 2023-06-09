import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';

class DeleteMeetingConfirm extends StatefulWidget {
  final String meetingGuid;
  const DeleteMeetingConfirm({
    Key? key,
    required this.meetingGuid,
  }) : super(key: key);

  @override
  State<DeleteMeetingConfirm> createState() => _DeleteMeetingConfirmState();
}

class _DeleteMeetingConfirmState extends State<DeleteMeetingConfirm> {
  final meetingsController = Get.find<MeetingsController>();

  Future<void> closeThenDelete() async {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Heading4(
              text: 'Please Confirm',
            ),
            const Body1(
              text: "Are you sure you want to delete this meeting?",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    closeThenDelete().then((value) {
                      meetingsController.deleteMeeting(
                        widget.meetingGuid,
                      );
                    });
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
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
