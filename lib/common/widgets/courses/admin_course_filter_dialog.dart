import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/admin/courses/courses_controller.dart';

class AdminCourseFilterDialog extends StatelessWidget {
  AdminCourseFilterDialog({
    Key? key,
  }) : super(key: key);

  final coursesController = Get.find<CoursesController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
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
                    value: coursesController.numResults.value,
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
                    selectedItemBuilder: (BuildContext context) =>
                        coursesController.perPageOptions
                            .map<Widget>(
                              (item) => DropdownMenuItem(
                                value: item.value,
                                child: Text(
                                  item.label,
                                ),
                              ),
                            )
                            .toList(),
                    items: coursesController.perPageOptions
                        .map(
                          (item) =>
                              (item.value == coursesController.numResults.value)
                                  ? DropdownMenuItem(
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
                                    )
                                  : DropdownMenuItem(
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
                                    ),
                        )
                        .toList(),
                    onChanged: (changedValue) {
                      coursesController.numResults(changedValue);
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
                    value: coursesController.orderBy.value,
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
                      return coursesController.orderByOptions
                          .map<Widget>((item) {
                        return DropdownMenuItem(
                          value: item.value,
                          child: Text(
                            item.label,
                          ),
                        );
                      }).toList();
                    },
                    items: coursesController.orderByOptions.map((item) {
                      if (item.value == coursesController.orderBy.value) {
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
                      coursesController.orderBy(changedValue);
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
                    value: coursesController.status.value,
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
                      return coursesController.statusOptions
                          .map<Widget>((item) {
                        return DropdownMenuItem(
                          value: item.value,
                          child: Text(
                            item.label,
                          ),
                        );
                      }).toList();
                    },
                    items: coursesController.statusOptions.map((item) {
                      if (item.value == coursesController.status.value) {
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
                      coursesController.status(changedValue);
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
                          coursesController.numResults('15');
                          coursesController.orderBy('newest_first');
                          coursesController.status('1');
                          coursesController.fetchCourses();
                          Get.back();
                        }
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        if (Get.isDialogOpen!) {
                          coursesController.fetchCourses();
                          Get.back();
                        }
                      },
                      child: const Text(
                        'Apply',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
