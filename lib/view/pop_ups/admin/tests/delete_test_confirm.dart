import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/labeled_checkbox.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';

class DeleteTestConfirm extends StatefulWidget {
  const DeleteTestConfirm({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteTestConfirm> createState() => _DeleteTestConfirmState();
}

class _DeleteTestConfirmState extends State<DeleteTestConfirm> {
  final globalController = Get.find<GlobalController>();
  final testsController = Get.find<TestsController>();
  final testController = Get.find<AdminTestController>();

  bool _deleteForEver = false;

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
              "Are you sure you want to delete this test?",
              style: Get.textTheme.headline6,
            ),
            LabeledCheckbox(
              label: 'Delete Forever.',
              onChanged: (bool newValue) {
                setState(() {
                  _deleteForEver = newValue;
                });
              },
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: _deleteForEver,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (Get.isDialogOpen!) {
                      String message =
                          await testController.deleteTest(_deleteForEver);
                      Get.back();
                      Get.back();
                      if (message.isNotEmpty) {
                        Get.snackbar(
                          "Success",
                          message,
                          icon: const Icon(
                            Icons.check,
                            color: white,
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: globalController.mainColor,
                          colorText: white,
                        );
                      }
                      testsController.fetchTests();
                    }
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) Get.back();
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
