// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_section_controller.dart';

import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';

class AdminAddLessonSectionPopup extends StatefulWidget {
  static String routeName = "/a/add-lesson-section";
  final String title;

  const AdminAddLessonSectionPopup({super.key, required this.title});

  @override
  State<AdminAddLessonSectionPopup> createState() =>
      _AdminAddLessonSectionPopupState();
}

class _AdminAddLessonSectionPopupState
    extends State<AdminAddLessonSectionPopup> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonController = Get.find<AdminLessonsController>();
  final lessonSectionController = Get.find<AdminLessonSectionController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: {
          'title': '',
          'created_by': authController.userGuId.value,
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
                FormBuilderTextInputField(
                  fieldName: 'title',
                  hintText: 'Enter Title',
                  labelText: 'Title',
                  isRequired: true,
                  onChanged: (String? val) {},
                ),
                FormBuilderField(
                  name: "created_by",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) =>
                      const SizedBox.shrink(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: lessonSectionController.isLoading.value ==
                                  false
                              ? () async {
                                  _formKey.currentState?.saveAndValidate();
                                  if (_formKey.currentState!.isValid) {
                                    final formData =
                                        _formKey.currentState!.value;
                                    final Map<String, String> parsedFormData =
                                        formData.map((key, value) {
                                      return MapEntry(
                                        key,
                                        value!.toString(),
                                      );
                                    });
                                    print(parsedFormData);
                                    FocusScope.of(context).unfocus();
                                    lessonSectionController
                                        .addUpdateSection(parsedFormData);
                                  }
                                }
                              : null,
                          child: Text(
                            lessonSectionController.isLoading.value == false
                                ? 'Save'
                                : 'Saving',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
