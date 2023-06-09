import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/models/lessons/lesson.dart';

class AdminEditLessonPopUp extends StatefulWidget {
  static String routeName = "/a/edit-lesson/:id";
  static String routePath = "/a/edit-lesson";
  final String title;

  const AdminEditLessonPopUp({super.key, required this.title});

  @override
  State<AdminEditLessonPopUp> createState() => _AdminEditLessonPopUpState();
}

class _AdminEditLessonPopUpState extends State<AdminEditLessonPopUp> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonsController = Get.find<AdminLessonsController>();
  final lessonController = Get.put(AdminLessonController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    lessonController.currentLessonGuid(
      lessonsController.currentLessonGuid.value,
    );
    lessonController.fetchLesson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Obx(
        () {
          if (lessonController.isLoading.value == true) {
            return const Loader();
          } else {
            Lesson lesson = lessonController.currentLesson;
            return FormBuilder(
              key: _formKey,
              initialValue: {
                'title': lesson.title,
                'description': lesson.description,
                'status': lesson.status,
                'created_by': authController.userGuId.value,
                'course_guid': courseController.currentCourseGuid.value,
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      FormBuilderTextField(
                        name: 'title',
                        decoration: const InputDecoration(
                          hintText: 'Enter Title',
                          labelText: 'Title*',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        contextMenuBuilder: (BuildContext context,
                            EditableTextState editableTextState) {
                          final List<ContextMenuButtonItem> buttonItems =
                              editableTextState.contextMenuButtonItems;
                          return AdaptiveTextSelectionToolbar.buttonItems(
                            anchors: editableTextState.contextMenuAnchors,
                            buttonItems: buttonItems,
                          );
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const FormBuilderHtmlField(
                        fieldName: 'description',
                        hintText: 'Enter Description',
                        isRequired: true,
                      ),
                      FormBuilderField(
                        name: "status",
                        enabled: false,
                        builder: (FormFieldState<dynamic> field) {
                          if (isDebug) {
                            print("status: ${field.value}");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      FormBuilderField(
                        name: "created_by",
                        enabled: false,
                        builder: (FormFieldState<dynamic> field) {
                          if (isDebug) {
                            print("created_by: ${field.value}");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      FormBuilderField(
                        name: "course_guid",
                        enabled: false,
                        builder: (FormFieldState<dynamic> field) {
                          if (isDebug) {
                            print("course_guid: ${field.value}");
                          }
                          return const SizedBox.shrink();
                        },
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
                                onPressed: lessonController.isLoading.value ==
                                        false
                                    ? () async {
                                        _formKey.currentState
                                            ?.saveAndValidate();
                                        final formData =
                                            _formKey.currentState!.value;
                                        final Map<String, String>
                                            parsedFormData =
                                            formData.map((key, value) {
                                          return MapEntry(
                                            key,
                                            value!.toString(),
                                          );
                                        });
                                        FocusScope.of(context).unfocus();
                                        lessonController
                                            .addUpdateLesson(parsedFormData);
                                      }
                                    : null,
                                child: Text(
                                  lessonController.isLoading.value == false
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
            );
          }
        },
      ),
    );
  }
}
