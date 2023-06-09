import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';

class AdminEditCoursePopUp extends StatefulWidget {
  static String routeName = "/edit-course/:guid";
  static String routePath = "/edit-course";
  final String title;

  const AdminEditCoursePopUp({super.key, required this.title});

  @override
  State<AdminEditCoursePopUp> createState() => _AdminEditCoursePopUpState();
}

class _AdminEditCoursePopUpState extends State<AdminEditCoursePopUp> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: {
          'title': courseController.currentCourse.title,
          'description': courseController.currentCourse.description,
          'status': courseController.currentCourse.status,
          'updated_by': authController.userGuId.value,
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
                  name: "updated_by",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) {
                    if (isDebug) {
                      print("updated_by: ${field.value}");
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
                          onPressed: () async {
                            _formKey.currentState?.saveAndValidate();
                            final formData = _formKey.currentState!.value;
                            final Map<String, String> parsedFormData =
                                formData.map((key, value) {
                              return MapEntry(
                                key,
                                value!.toString(),
                              );
                            });
                            if (isDebug) {
                              print(parsedFormData);
                            }
                            FocusScope.of(context).unfocus();
                            courseController.addUpdateCourse(parsedFormData);
                          },
                          child: const Text(
                            'Update',
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
