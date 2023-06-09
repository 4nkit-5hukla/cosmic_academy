import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_enrollment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnEnrollConfirm extends StatefulWidget {
  final String userGuid;
  const UnEnrollConfirm({
    Key? key,
    required this.userGuid,
  }) : super(key: key);

  @override
  State<UnEnrollConfirm> createState() => _UnEnrollConfirmState();
}

class _UnEnrollConfirmState extends State<UnEnrollConfirm> {
  final testEnrollmentController = Get.find<AdminTestEnrollMentController>();

  Future<void> closeThen() async {
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
                    closeThen().then((value) {
                      testEnrollmentController.unEnrollUsers(
                        {"users[0]": widget.userGuid},
                      );
                    });
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(white),
                    foregroundColor: MaterialStatePropertyAll<Color>(text1),
                  ),
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
