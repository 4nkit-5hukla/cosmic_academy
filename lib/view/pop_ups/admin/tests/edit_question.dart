import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_questions_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_drop_down_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_button.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';

import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_question_controller.dart';
import 'package:cosmic_assessments/models/questions/choice.dart';
import 'package:cosmic_assessments/models/questions/question.dart';

class AdminEditQuestionPopUp extends StatefulWidget {
  static String routeName = "/a/test/edit-question/:ques_guid";
  final String title;
  final String? quesGuid;

  const AdminEditQuestionPopUp({super.key, required this.title, this.quesGuid});

  @override
  State<AdminEditQuestionPopUp> createState() => _AdminEditQuestionPopUpState();
}

class _AdminEditQuestionPopUpState extends State<AdminEditQuestionPopUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final testQuestionsController = Get.find<TestQuestionsController>();
  final testQuestionController = Get.put(TestQuestionController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  Map<String, List<String>> choices = {
    'mcmc': ['', '', ''],
    'tf': ['true', 'false'],
    'la': [''],
    'comp': [''],
  };
  String question = '';
  String status = '0';
  String marks = '1';
  String negMarks = '0';
  String questionType = '';
  String? fieldName;
  String? filePath;
  List<dynamic>? getChoice(String questionType) {
    return questionType != '' ? choices[questionType] : [];
  }

  @override
  void initState() {
    testQuestionController
        .currentTestGuid(testController.currentTestGuid.value);
    testQuestionController.currentTestQuestionGuid(widget.quesGuid);
    testQuestionController.fetchTestQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() {
        if (testQuestionController.isLoading.value == true) {
          return const Loader();
        }
        Question testQuestion = testQuestionController.currentTestQuestion;
        List<dynamic>? currentChoice = getChoice(questionType);
        List<Choice>? testQuestionChoices = testQuestion.choices;
        print(currentChoice);
        print(testQuestion.questionType);
        return FormBuilder(
          key: _formKey,
          initialValue: {
            'question': testQuestion.question,
            // 'question_type': questionType,
            // 'choice': currentChoice,
            'feedback': testQuestion.feedback,
            'answer_feedback': testQuestion.answerFeedback,
            'created_by': authController.userGuId.value,
            'status': '1',
          },
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
                    initialValue: questionType != ''
                        ? questionType
                        : testQuestion.questionType,
                    isRequired: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'mcmc',
                        enabled: false,
                        child: Text(
                          'Multiple Correct',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'tf',
                        enabled: false,
                        child: Text(
                          'True or False',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'la',
                        enabled: false,
                        child: Text(
                          'Essay',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'comp',
                        enabled: false,
                        child: Text(
                          'Comprehension',
                        ),
                      ),
                    ],
                    onChanged: (String? value) => setState(
                      () => questionType = value!,
                    ),
                  ),
                  if (testQuestionChoices!.isNotEmpty)
                    if (testQuestion.questionType == 'mcmc')
                      Column(
                        children:
                            testQuestionChoices.asMap().entries.map((entry) {
                          int index = entry.key;
                          entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Choice ${(index + 1)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FormBuilderTextInputField(
                                fieldName: "position[$index]",
                                labelText: 'Position*',
                                initialValue: entry.value.position ??
                                    (index + 1).toString(),
                                isRequired: true,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FormBuilderHtmlField(
                                fieldName: "choice[$index]",
                                hintText: "Your Choice...",
                                isRequired: true,
                                initialValue: entry.value.choice,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FormBuilderRadioGroup(
                                name: 'correct_answer[$index]',
                                orientation: OptionsOrientation.horizontal,
                                initialValue: entry.value.correctAnswer,
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                  ],
                                ),
                                options: const [
                                  FormBuilderFieldOption(
                                    value: "1",
                                    child: Text('Yes'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: "0",
                                    child: Text('No'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Is Correct?',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                  if (testQuestionChoices.isNotEmpty)
                    if (testQuestion.questionType == 'tf')
                      Column(
                        children:
                            testQuestionChoices.asMap().entries.map((entry) {
                          int index = entry.key;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Choice ${(index + 1)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FormBuilderTextInputField(
                                fieldName: "position[$index]",
                                labelText: 'Position*',
                                initialValue: entry.value.position ??
                                    (index + 1).toString(),
                                isRequired: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FormBuilderCheckbox(
                                name: 'correct_answer[$index]',
                                initialValue: entry.value.correctAnswer == '0'
                                    ? false
                                    : true,
                                onChanged: (dynamic value) {},
                                title: Text(
                                    "Correct Choice ${entry.value.choice}"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FormBuilderTextInputField(
                                fieldName: "choice[$index]",
                                labelText: "Choice Label",
                                isRequired: true,
                                initialValue: entry.value.choice,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                  if (testQuestionChoices.isNotEmpty)
                    if (testQuestion.questionType == 'la' ||
                        testQuestion.questionType == 'comp')
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
                          FormBuilderHtmlField(
                            fieldName: "choice[0]",
                            hintText: "Enter Sample Answer...",
                            isRequired: true,
                            initialValue: testQuestionChoices[0].choice,
                          ),
                          FormBuilderField(
                            name: "correct_answer[0]",
                            enabled: false,
                            initialValue: true,
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
                  if (testQuestion.questionType == 'mcmc') spaceV20,
                  if (testQuestion.questionType == 'mcmc')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FormButton(
                          label: 'Add More Choice',
                          onPressed: () {
                            testQuestionChoices.add(Choice(
                              choice: '',
                              position:
                                  (testQuestionChoices.length + 1).toString(),
                              correctAnswer: '',
                            ));
                            testQuestionController.update();
                          },
                        ),
                      ],
                    ),
                  spaceV15,
                  const Heading4(text: 'Marks'),
                  spaceV20,
                  FormBuilderTextInputField(
                    fieldName: 'marks',
                    labelText: '',
                    isRequired: true,
                    initialValue:
                        testQuestion.marks != '' ? testQuestion.marks : marks,
                    keyboardType: TextInputType.number,
                  ),
                  spaceV15,
                  const Heading4(text: 'Negative Marks'),
                  spaceV20,
                  FormBuilderTextInputField(
                    fieldName: 'neg_marks',
                    labelText: '',
                    isRequired: true,
                    initialValue: testQuestion.negMarks != ''
                        ? testQuestion.negMarks
                        : negMarks,
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
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState?.saveAndValidate();
                              final formData = _formKey.currentState!.value;
                              final Map<String, String> parsedFormData =
                                  formData.map((key, value) {
                                if (value is bool) {
                                  return MapEntry(
                                    key.toString(),
                                    (value ? '1' : '0').toString(),
                                  );
                                } else if (value == null) {
                                  return MapEntry(key, '');
                                }
                                return MapEntry(
                                  key.toString(),
                                  value!.toString(),
                                );
                              });
                              String message =
                                  await testQuestionController.updateQuestion(
                                      parsedFormData, fieldName, filePath);
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
                              testQuestionsController.fetchTestQuestions(true);
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
        );
      }),
    );
  }
}
