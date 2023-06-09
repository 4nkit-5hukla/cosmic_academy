import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';

class AdminTestSortDialog extends StatelessWidget {
  AdminTestSortDialog({
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Heading2(
                      text: 'Sort By',
                    ),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 26,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Get.isDialogOpen!) {
                            testsController.fetchTests();
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Body1(
                          text: 'Apply',
                          color: white,
                        ),
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
