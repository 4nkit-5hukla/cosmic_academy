import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersFilterDialog extends StatelessWidget {
  const UsersFilterDialog({
    super.key,
    required this.usersController,
    required this.onApply,
  });

  final UsersController usersController;
  final Function onApply;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filters',
                  style: Get.textTheme.headline4,
                ),
                spaceV10,
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: usersController.numResults.value,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'Results Per Page',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return usersController.perPageOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: usersController.perPageOptions.map((item) {
                        if (item.value == usersController.numResults.value) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              color: Colors.grey,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                      onChanged: (changedValue) {
                        usersController.numResults(
                          changedValue,
                        );
                      },
                    ),
                  ),
                ),
                spaceV10,
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: usersController.orderBy.value,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'Order By',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return usersController.orderByOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: usersController.orderByOptions.map((item) {
                        if (item.value == usersController.orderBy.value) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              color: Colors.grey,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                      onChanged: (changedValue) {
                        usersController.orderBy(changedValue);
                      },
                    ),
                  ),
                ),
                spaceV10,
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: usersController.role.value,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'User Roles',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return usersController.roleOptions.map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: usersController.roleOptions.map((item) {
                        if (item.value == usersController.role.value) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              color: Colors.grey,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                      onChanged: (changedValue) {
                        usersController.role(changedValue);
                      },
                    ),
                  ),
                ),
                spaceV10,
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: usersController.archived.value,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'Archived',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return usersController.archivedOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Body1(
                              text: item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: usersController.archivedOptions.map((item) {
                        if (item.value == usersController.archived.value) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              color: text1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Body1(
                                    text: item.label,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Body1(
                                    text: item.label,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                      onChanged: (changedValue) {
                        usersController.archived(
                          changedValue,
                        );
                      },
                    ),
                  ),
                ),
                spaceV10,
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: usersController.status.value,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'Status',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return usersController.statusOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Body1(
                              text: item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: usersController.statusOptions.map((item) {
                        if (item.value == usersController.archived.value) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              color: text1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Body1(
                                    text: item.label,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              height: 48.0,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Body1(
                                    text: item.label,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                      onChanged: (changedValue) {
                        usersController.status(
                          changedValue,
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
                            usersController.fetchUsers().then((value) {
                              onApply();
                            });
                            Get.back();
                          }
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
