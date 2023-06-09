// ignore_for_file: avoid_print

import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';

import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';

class AdminAddLessonContentPopup extends StatefulWidget {
  static String routeName = "/a/add-lesson-content";
  final String title;

  const AdminAddLessonContentPopup({super.key, required this.title});

  @override
  State<AdminAddLessonContentPopup> createState() =>
      _AdminAddLessonContentPopupState();
}

class _AdminAddLessonContentPopupState
    extends State<AdminAddLessonContentPopup> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonController = Get.find<AdminLessonsController>();
  final lessonContentController = Get.put(AdminLessonContentController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String _currentType = 'html';
  PlatformFile? file;
  List<String> contentType = <String>[
    'html',
    'file',
    'link',
  ];

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
          'type': _currentType,
          'content': '',
          'status': '0',
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
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: FormBuilderDropdown<String>(
                      name: 'type',
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'Content Type',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      items: contentType
                          .map(
                            (String type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type == 'html'
                                    ? 'Rich Text'
                                    : type.capitalizeFirst!,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _currentType = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_currentType == 'html')
                  const FormBuilderHtmlField(
                    fieldName: 'content',
                    labelText: 'Content',
                    hintText: 'Enter Content',
                    isRequired: true,
                  ),
                if (_currentType == 'link')
                  FormBuilderTextInputField(
                    fieldName: 'content',
                    hintText: 'Enter URL',
                    prefixIcon: const Icon(
                      Icons.link_outlined,
                    ),
                    labelText: _currentType.capitalizeFirst!,
                    isRequired: true,
                    isURL: true,
                    onChanged: (String? val) {},
                  ),
                if (_currentType == 'file')
                  FormBuilderFilePicker(
                    name: 'file',
                    previewImages: true,
                    allowMultiple: false,
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    customFileViewerBuilder: (
                      List<PlatformFile>? files,
                      FormFieldSetter<List<PlatformFile>> setter,
                    ) =>
                        ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        return ListTile(
                          title: Text(file.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              files.removeAt(index);
                              setter.call([...files]);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      itemCount: files!.length,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Select a file',
                      hintText: 'No file selected',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    onChanged: (List<PlatformFile>? files) {
                      if (files!.isNotEmpty) {
                        setState(() {
                          file = files[0];
                        });
                      }
                    },
                  ),
                FormBuilderField(
                  name: "status",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) =>
                      const SizedBox.shrink(),
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
                          onPressed: lessonContentController.isLoading.value ==
                                  false
                              ? () async {
                                  if (_currentType == 'file') {
                                    _formKey.currentState?.saveAndValidate();
                                    if (file != null) {
                                      print(file);
                                      lessonContentController
                                          .uploadFile(
                                        "userfile",
                                        file!.path.toString(),
                                        authController.userGuId.value,
                                      )
                                          .then((value) {
                                        Get.back();
                                      });
                                    }
                                  } else {
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
                                      lessonContentController
                                          .addUpdateContent(parsedFormData);
                                    }
                                  }
                                }
                              : null,
                          child: Text(
                            lessonContentController.isLoading.value == false
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
