import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/question_choices/mcmc.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/question_choices/truefalse.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_drop_down_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';

import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_question_controller.dart';

class AdminAddQuestionPopUp extends StatefulWidget {
  static String routeName = "/a/test/add-question";
  final String title;

  const AdminAddQuestionPopUp({super.key, required this.title});

  @override
  State<AdminAddQuestionPopUp> createState() => _AdminAddQuestionPopUpState();
}

class _AdminAddQuestionPopUpState extends State<AdminAddQuestionPopUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final testController = Get.put(AdminTestController());
  final testQuestionController = Get.put(TestQuestionController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  Map<String, List<String>> choices = {
    'mcmc': ['', '', ''],
    'tf': ['true', 'false'],
    'la': [''],
    'comp': [''],
  };
  Map<String, List<String>> position = {
    'mcmc': ['1', '2', '3'],
    'tf': ['1', '2'],
    'la': ['1'],
    'comp': ['1'],
  };
  String question = '';
  String status = '1';
  String marks = '1';
  String negMarks = '0';
  String questionType = 'mcmc';
  String? fieldName;
  String? filePath;
  List<dynamic>? getChoice(String questionType) {
    return questionType != '' ? choices[questionType] : [];
  }

  List<dynamic>? getPosition(String questionType) {
    return questionType != '' ? position[questionType] : [];
  }

  @override
  void initState() {
    // TODO: implement initState
    testQuestionController
        .currentTestGuid(testController.currentTestGuid.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic>? currentChoice = getChoice(questionType);
    List<dynamic>? currentPosition = getPosition(questionType);
    Map<String, Object?> initialValue = {
      'question': '',
      'question_type': questionType,
      'status': '1',
      'marks': '',
      'neg_marks': '',
      'choice': currentChoice,
      'position': currentPosition,
      'correct_answer': currentChoice,
      'feedback': '',
      'answer_feedback': '',
      'created_by': authController.userGuId.value,
    };

    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      drawer: AdminSidebar(),
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: initialValue,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
                const Heading4(text: 'Question'),
                spaceV15,
                const FormBuilderHtmlField(
                  fieldName: 'question',
                  hintText: 'Type your question here...',
                  isRequired: true,
                ),
                spaceV15,
                const Heading4(text: 'Attach File'),
                spaceV10,
                FormBuilderFilePicker(
                  name: 'file',
                  previewImages: true,
                  allowMultiple: false,
                  typeSelectors: [
                    TypeSelector(
                      type: FileType.any,
                      selector: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: text2, // specify the color of the border
                            width: 1, // specify the width of the border
                          ),
                        ),
                        child: const Icon(
                          Icons.upload_rounded,
                          size: 32,
                          color: secondary,
                        ),
                      ),
                    ),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (List<PlatformFile>? files) {
                    if (files!.isNotEmpty) {
                      setState(() {
                        fieldName = "userfile";
                        filePath = files.first.path.toString();
                      });
                    }
                  },
                ),
                spaceV10,
                const Heading4(text: 'Type'),
                spaceV20,
                FormBuilderDropDownField(
                  fieldName: 'question_type',
                  labelText: '',
                  initialValue: questionType,
                  isRequired: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'mcmc',
                      child: Text(
                        'Multiple Correct',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'tf',
                      child: Text(
                        'True or False',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'la',
                      child: Text(
                        'Essay',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'comp',
                      child: Text(
                        'Comprehension',
                      ),
                    ),
                  ],
                  onChanged: (String? value) => setState(
                    () => questionType = value!,
                  ),
                ),
                if (currentChoice!.isNotEmpty)
                  if (questionType == 'mcmc')
                    Column(
                      children: currentChoice.asMap().entries.map((entry) {
                        int index = entry.key;
                        return MCMC(
                          index: index,
                        );
                      }).toList(),
                    ),
                if (currentChoice.isNotEmpty)
                  if (questionType == 'tf')
                    Column(
                      children: currentChoice.asMap().entries.map((entry) {
                        int index = entry.key;
                        String value = entry.value;
                        return TrueFalse(
                          formKey: _formKey,
                          index: index,
                          value: value,
                        );
                      }).toList(),
                    ),
                if (currentChoice.isNotEmpty)
                  if (questionType == 'la' || questionType == 'comp')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Sample Answer"),
                        const SizedBox(
                          height: 20,
                        ),
                        const FormBuilderHtmlField(
                          fieldName: "choice[0]",
                          hintText: "Enter Sample Answer...",
                          isRequired: true,
                        ),
                        FormBuilderField(
                          name: "correct_answer[0]",
                          enabled: false,
                          initialValue: '1',
                          builder: (FormFieldState<dynamic> field) =>
                              const SizedBox.shrink(),
                        ),
                        FormBuilderField(
                          name: "position[0]",
                          enabled: false,
                          initialValue: '1',
                          builder: (FormFieldState<dynamic> field) =>
                              const SizedBox.shrink(),
                        ),
                      ],
                    ),
                if (questionType == 'mcmc') spaceV20,
                if (questionType == 'mcmc')
                  SizedBox(
                    height: 35,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Body1(
                        text: 'Add Choice',
                        color: white,
                      ),
                      onPressed: () {
                        setState(() {
                          currentChoice.add('');
                        });
                      },
                    ),
                  ),
                spaceV15,
                const Heading4(text: 'Marks'),
                spaceV20,
                FormBuilderTextInputField(
                  fieldName: 'marks',
                  labelText: '',
                  isRequired: true,
                  initialValue: marks,
                  keyboardType: TextInputType.number,
                ),
                spaceV15,
                const Heading4(text: 'Negative Marks'),
                spaceV20,
                FormBuilderTextInputField(
                  fieldName: 'neg_marks',
                  labelText: '',
                  isRequired: true,
                  initialValue: negMarks,
                  keyboardType: TextInputType.number,
                ),
                spaceV15,
                const Heading4(text: 'Question Feedback'),
                spaceV20,
                const FormBuilderHtmlField(
                  fieldName: 'feedback',
                  hintText: 'Provide question feedback...',
                ),
                spaceV15,
                const Heading4(text: 'Answer Feedback'),
                spaceV20,
                const FormBuilderHtmlField(
                  fieldName: 'answer_feedback',
                  hintText: 'Provide answer question feedback...',
                ),
                FormBuilderField(
                  name: "created_by",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) {
                    return const SizedBox.shrink();
                  },
                ),
                FormBuilderField(
                  name: "status",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) {
                    return const SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            _formKey.currentState?.saveAndValidate();
                            Map<String, dynamic> formData =
                                _formKey.currentState!.value;
                            final Map<String, String> parsedFormData =
                                Map.fromEntries(formData.entries
                                        .where((entry) => entry.value != null))
                                    .map((key, value) {
                              if (value is bool) {
                                return MapEntry(
                                  key.toString(),
                                  (value ? '1' : '0').toString(),
                                );
                              } else if (value == null) {
                                return MapEntry(key, '');
                              } else {
                                return MapEntry(
                                  key.toString(),
                                  value!.toString(),
                                );
                              }
                            });
                            if (questionType == 'tf') {
                              parsedFormData.remove('correct_answer[2]');
                              parsedFormData.remove('position[2]');
                            }
                            if (questionType == 'la' ||
                                questionType == 'comp') {
                              parsedFormData['correct_answer[0]'] = '1';
                              parsedFormData.remove('correct_answer[1]');
                              parsedFormData.remove('correct_answer[2]');
                              parsedFormData.remove('position[1]');
                              parsedFormData.remove('position[2]');
                            }
                            // print(parsedFormData);

                            String message =
                                await testQuestionController.addQuestion(
                              parsedFormData,
                              fieldName,
                              filePath,
                            );
                            await testController.fetchTest();
                            Get.back();
                            if (message.isNotEmpty) {
                              Get.snackbar(
                                "Success",
                                message,
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: globalController.mainColor,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text('Save'),
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
