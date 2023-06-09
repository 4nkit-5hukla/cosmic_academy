import 'package:cosmic_assessments/common/utils/pluralize.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/users/users_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ChangeRoleDialog extends StatefulWidget {
  const ChangeRoleDialog({
    super.key,
    required this.usersController,
    required this.selectedUsers,
  });

  final UsersController usersController;
  final List<String> selectedUsers;

  @override
  State<ChangeRoleDialog> createState() => _ChangeRoleDialogState();
}

class _ChangeRoleDialogState extends State<ChangeRoleDialog> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Heading3(
              text:
                  "Change Selected ${pluralize(widget.selectedUsers.length, "User")} Role",
            ),
            spaceV10,
            DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: FormBuilderDropdown<String>(
                  name: 'role',
                  initialValue: authController.defaultUserRole.value,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 16.0,
                    ),
                    labelText: 'Change Role to',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                    ),
                  ),
                  items: userRoles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role.replaceAll('_', ' ').capitalize!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    widget.usersController.role(
                      newValue,
                    );
                  },
                ),
              ),
            ),
            spaceV10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 48,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(
                  height: 48,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Get.isDialogOpen!) {
                        Map<String, String> selectedUsers =
                            widget.selectedUsers.asMap().map((index, userGuid) {
                          return MapEntry(
                            "roles[$userGuid]",
                            widget.usersController.role.value,
                          );
                        });
                        selectedUsers.addAll({
                          'created_by': authController.userGuId.value.isNotEmpty
                              ? authController.userGuId.value
                              : authController.defaultUserRole.value,
                        });
                        widget.usersController.changeRole(selectedUsers);
                        Get.back();
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
