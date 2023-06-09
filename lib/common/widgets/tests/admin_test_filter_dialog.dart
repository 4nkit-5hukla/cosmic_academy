import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';

class AdminTestFilterDialog extends StatelessWidget {
  AdminTestFilterDialog({
    Key? key,
  }) : super(key: key);

  final testsController = Get.find<TestsController>();

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
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: testsController.numResults.value,
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
                        return testsController.perPageOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: testsController.perPageOptions.map((item) {
                        if (item.value == testsController.numResults.value) {
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
                        testsController.numResults(changedValue);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: testsController.orderBy.value,
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
                        return testsController.orderByOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: testsController.orderByOptions.map((item) {
                        if (item.value == testsController.orderBy.value) {
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
                        testsController.orderBy(changedValue);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      value: testsController.status.value,
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
                        return testsController.statusOptions
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(
                              item.label,
                            ),
                          );
                        }).toList();
                      },
                      items: testsController.statusOptions.map((item) {
                        if (item.value == testsController.status.value) {
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
                        testsController.status(changedValue);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Get.isDialogOpen!) {
                            testsController.numResults('15');
                            testsController.orderBy('newest_first');
                            testsController.status('1');
                            testsController.fetchTests();
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
                            testsController.fetchTests();
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
