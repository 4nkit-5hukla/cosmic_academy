import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';

class TestSubmitDialog extends StatelessWidget {
  final TimerCountdown? timer;
  final Function onSubmit;
  final int attemptCount;
  final int unAttemptCount;
  final int markedCount;
  const TestSubmitDialog({
    Key? key,
    required this.onSubmit,
    required this.timer,
    required this.attemptCount,
    required this.unAttemptCount,
    required this.markedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (timer != null)
              ListTile(
                leading: const Body1(
                  text: 'Time Left',
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: timer,
                ),
                dense: true,
              ),
            if (timer != null)
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle_outline),
                      spaceH10,
                      Body1(text: "Attempted"),
                    ],
                  ),
                  Body1(text: "$attemptCount"),
                ],
              ),
              dense: true,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
              height: 0,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.remove_circle_outline),
                      spaceH10,
                      Body1(text: "Not Attempted"),
                    ],
                  ),
                  Body1(text: "$unAttemptCount"),
                ],
              ),
              dense: true,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
              height: 0,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.timer),
                      spaceH10,
                      Body1(text: "Visit Later"),
                    ],
                  ),
                  Body1(text: "$markedCount"),
                ],
              ),
              dense: true,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Heading4(
                text: 'Are you sure you want to submit the test?',
                bold: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (Get.isDialogOpen!) {
                          Get.back();
                          onSubmit();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: const Heading4(
                          text: "Yes",
                          color: white,
                        ),
                      ),
                    ),
                  ),
                  spaceH10,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (Get.isDialogOpen!) {
                          Get.back();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: secondary,
                        ),
                        alignment: Alignment.center,
                        child: const Heading4(
                          text: "No",
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
