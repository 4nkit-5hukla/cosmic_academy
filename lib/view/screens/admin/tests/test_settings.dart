import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AdminTestSettings extends StatefulWidget {
  static String routeName = "/a/test/settings/:guid";
  static String routePath = "/a/test/settings";
  final String title;
  const AdminTestSettings({super.key, required this.title});

  @override
  State<AdminTestSettings> createState() => _AdminTestSettingsState();
}

class _AdminTestSettingsState extends State<AdminTestSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool showOnDate = false;

  @override
  Widget build(BuildContext context) {
    // print(testController.currentTest);
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
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
      drawer: AdminSidebar(),
      body: Obx(
        () {
          if (testController.isLoading.value == true) {
            return const Loader();
          } else {
            Test test = testController.currentTest;
            Settings testSettings = test.settings;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Heading4(text: 'Marks Per Question'),
                      spaceV15,
                      FormBuilderTextInputField(
                        fieldName: 'marks_per_question',
                        hintText: 'Enter Marks Per Question',
                        labelText: null,
                        initialValue: testSettings.marksPerQuestion,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                      spaceV15,
                      const Heading4(text: 'Number of attempts'),
                      spaceV15,
                      FormBuilderTextInputField(
                        fieldName: 'num_attempts',
                        hintText: 'Enter Number of attempts',
                        labelText: null,
                        initialValue: testSettings.numAttempts,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                      spaceV15,
                      const Heading4(text: 'Test Duration (in minutes)'),
                      spaceV15,
                      FormBuilderTextInputField(
                        fieldName: 'test_duration',
                        hintText: 'Enter Test Duration',
                        labelText: null,
                        initialValue: testSettings.testDuration,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                      spaceV15,
                      const Heading4(text: 'Negative Marking'),
                      spaceV15,
                      FormBuilderTextInputField(
                        fieldName: 'neg_marks_per_question',
                        hintText: 'Enter Negative Marking',
                        labelText: null,
                        initialValue: testSettings.negMarksPerQuestion,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                      spaceV15,
                      const Heading4(text: 'Passing Mark'),
                      spaceV15,
                      FormBuilderTextInputField(
                        fieldName: 'pass_marks',
                        hintText: 'Enter Passing Mark',
                        labelText: null,
                        initialValue: testSettings.passMarks ?? "",
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                      spaceV15,
                      FormBuilderSwitch(
                        name: 'show_timer',
                        initialValue:
                            testSettings.showTimer == "true" ? true : false,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          fillColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        title: const Heading4(text: 'Show Timer'),
                      ),
                      spaceV15,
                      const Heading4(text: 'Show Result '),
                      FormBuilderRadioGroup(
                        name: 'show_result',
                        initialValue: testSettings.showResult,
                        orientation: OptionsOrientation.vertical,
                        options: const [
                          FormBuilderFieldOption(
                            key: Key('immediately'),
                            value: "immediately",
                            child: Text('Immediately'),
                          ),
                          FormBuilderFieldOption(
                            key: Key('manually'),
                            value: "manually",
                            child: Text('Manually'),
                          ),
                          FormBuilderFieldOption(
                            key: Key('on_date'),
                            value: "on_date",
                            child: Text('On Date'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value == 'on_date') {
                            setState(() {
                              showOnDate = true;
                            });
                          } else {
                            setState(() {
                              showOnDate = false;
                            });
                          }
                        },
                      ),
                      if (showOnDate) spaceV15,
                      if (showOnDate) const Heading4(text: 'On Date'),
                      spaceV15,
                      if (showOnDate)
                        FormBuilderTextInputField(
                          fieldName: 'on_date',
                          hintText: 'DD/MM/YYYY',
                          labelText: null,
                          initialValue: testSettings.onDate,
                          keyboardType: TextInputType.datetime,
                          isRequired: true,
                        ),
                      spaceV15,
                      Row(
                        children: [
                          SizedBox(
                            height: 35,
                            width: 165,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                _formKey.currentState?.saveAndValidate();
                                final formData = _formKey.currentState!.value;
                                final Map<String, String> parsedFormData =
                                    formData.map(
                                  (key, value) => MapEntry(
                                    key,
                                    value!.toString(),
                                  ),
                                );
                                String message = await testController
                                    .saveTestSettings(parsedFormData);
                                Get.back();
                                if (message.isNotEmpty) {
                                  Get.snackbar(
                                    "Success",
                                    message,
                                    icon: const Icon(
                                      Icons.check,
                                      color: white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    colorText: white,
                                    backgroundColor: globalController.mainColor,
                                  );
                                }
                              },
                              child: const Body1(
                                text: 'Save Settings',
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
        },
      ),
    );
  }
}
