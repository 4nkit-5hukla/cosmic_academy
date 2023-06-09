// ignore_for_file: avoid_print

import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_section_controller.dart';

import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/courses/course_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lessons_controller.dart';
import 'package:cosmic_assessments/controllers/admin/lessons/lesson_content_controller.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/models/lessons/lesson_content.dart';

class AdminEditLessonContentPopup extends StatefulWidget {
  static String routeName = "/a/edit-lesson-content/:guid";
  static String routePath = "/a/edit-lesson-content";
  final String title;

  const AdminEditLessonContentPopup({super.key, required this.title});

  @override
  State<AdminEditLessonContentPopup> createState() =>
      _AdminEditLessonContentPopupState();
}

class _AdminEditLessonContentPopupState
    extends State<AdminEditLessonContentPopup> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final courseController = Get.find<AdminCourseController>();
  final lessonController = Get.find<AdminLessonsController>();
  final lessonSectionController = Get.find<AdminLessonSectionController>();
  final lessonContentController = Get.put(AdminLessonContentController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  PlatformFile? file;
  List<String> contentType = <String>[
    'html',
    'file',
    'link',
  ];

  @override
  Widget build(BuildContext context) {
    LessonContent currentContent = lessonContentController.currentContent;
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
          'type': currentContent.type,
          'status': currentContent.status,
          'content_id': currentContent.contentId,
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
                      items: contentType.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type == 'html'
                                ? 'Rich Text'
                                : type == 'youtube'
                                    ? 'Embedded Video'
                                    : type.capitalizeFirst!,
                          ),
                        );
                      }).toList(),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (currentContent.type == 'html')
                  FormBuilderHtmlField(
                    fieldName: 'content',
                    labelText: 'Content',
                    hintText: 'Enter Content',
                    initialValue: currentContent.content,
                    isRequired: true,
                  ),
                if (currentContent.type == 'link')
                  FormBuilderTextInputField(
                    fieldName: 'content',
                    hintText: 'Enter URL',
                    initialValue: currentContent.content,
                    prefixIcon: const Icon(
                      Icons.link_outlined,
                    ),
                    labelText: currentContent.type.capitalizeFirst!,
                    isRequired: true,
                    isURL: true,
                  ),
                if (currentContent.type == 'file')
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
                if (currentContent.type == 'file')
                  const SizedBox(
                    height: 10,
                  ),
                if (currentContent.type == 'file')
                  FormBuilderTextInputField(
                    fieldName: 'file_hash',
                    labelText: 'File Hash',
                    enabled: false,
                    initialValue: currentContent.fileHash!,
                  ),
                if (currentContent.type == 'file')
                  FormBuilderField(
                    name: "section_id",
                    enabled: false,
                    initialValue:
                        lessonSectionController.currentSectionGuid.value,
                    builder: (FormFieldState<dynamic> field) =>
                        const SizedBox.shrink(),
                  ),
                if (currentContent.type != 'file')
                  FormBuilderField(
                    name: "status",
                    enabled: false,
                    builder: (FormFieldState<dynamic> field) =>
                        const SizedBox.shrink(),
                  ),
                if (currentContent.type != 'file')
                  FormBuilderField(
                    name: "content_id",
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
                                  if (currentContent.type == 'file') {
                                    _formKey.currentState?.saveAndValidate();
                                    if (file != null) {
                                      print(file);
                                      lessonContentController
                                          .replaceFile(
                                        "userfile",
                                        file!.path.toString(),
                                        currentContent.fileHash!,
                                        authController.userGuId.value,
                                      )
                                          .then((value) {
                                        Get.back();
                                      });
                                    }
                                  } else {
                                    _formKey.currentState?.saveAndValidate();
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
                                    lessonContentController.addUpdateContent(
                                      parsedFormData,
                                      true,
                                    );
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
