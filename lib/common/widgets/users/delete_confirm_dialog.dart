import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/labeled_checkbox.dart';
import 'package:cosmic_assessments/controllers/admin/users/user_controller.dart';

class DeleteConfirmDialog extends StatefulWidget {
  const DeleteConfirmDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  final userController = Get.find<UserController>();

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
              "Are you sure you want to delete this user",
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
                  onPressed: () {
                    if (Get.isDialogOpen!) {
                      userController.deleteUser(_deleteForEver);
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
