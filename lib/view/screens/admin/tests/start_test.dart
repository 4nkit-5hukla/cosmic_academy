import 'package:cosmic_assessments/common/utils/get_time.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_run.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class AdminStartTestScreen extends StatefulWidget {
  static String routeName = "/a/test/start/:guid";
  static String routePath = "/a/test/start";
  final String title;

  const AdminStartTestScreen({super.key, required this.title});

  @override
  State<AdminStartTestScreen> createState() => _AdminStartTestScreenState();
}

class _AdminStartTestScreenState extends State<AdminStartTestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String routePath = AdminTestRunScreen.routePath;
    String currentTestGuid = testController.currentTestGuid.value;
    Test currentTest = testController.currentTest;
    String currentTestName = testController.currentTest.title;

    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          currentTest.title,
        ),
      ),
      drawer: AdminSidebar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    spaceV15,
                    const Heading4(
                      text: "Please read the instructions carefully",
                    ),
                    const Heading4(
                      text: "(कृपया निर्देशों को ध्यान से पढ़ें)",
                    ),
                    spaceV15,
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Body1(
                            text: '1',
                            color: white,
                          ),
                        ),
                        spaceH10,
                        Body1(
                          text:
                              'Total Question : ${currentTest.stats?.questions}',
                          color: text1,
                        ),
                      ],
                    ),
                    spaceV10,
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Body1(
                            text: '2',
                            color: white,
                          ),
                        ),
                        spaceH10,
                        Body1(
                          text:
                              'Marks For Correct : ${currentTest.settings.marksPerQuestion}',
                          color: text1,
                        ),
                      ],
                    ),
                    spaceV10,
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Body1(
                            text: '3',
                            color: white,
                          ),
                        ),
                        spaceH10,
                        Body1(
                          text:
                              'Marks For Wrong : ${currentTest.settings.negMarksPerQuestion}',
                          color: text1,
                        ),
                      ],
                    ),
                    spaceV10,
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Body1(
                            text: '2',
                            color: white,
                          ),
                        ),
                        spaceH10,
                        Body1(
                          text: 'Time : ${getTime(
                            int.parse(
                              currentTest.settings.testDuration,
                            ),
                          )}',
                          color: text1,
                        ),
                      ],
                    ),
                    spaceV15,
                    const Body1(
                      text:
                          "Bookmark Questions: The Marked for Review status for a question simply indicates that you would like to look at that question again. Selected answer will be considered for evaluation.( बुकमार्क प्रश्न: किसी प्रश्न के लिए समीक्षा की स्थिति के लिए चिह्नित किया गया संकेत केवल यह दर्शाता है कि आप उस प्रश्न को फिर से देखना चाहेंगे। चयनित उत्तर मूल्यांकन के लिए मान्य होगा )",
                    ),
                  ],
                ),
              ),
              spaceV10,
              FormBuilder(
                key: _formKey,
                initialValue: const {
                  'read': false,
                },
                child: FormBuilderField(
                  name: "read",
                  key: Key(
                    UniqueKey().toString(),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.notEqual(false),
                    ],
                  ),
                  builder: (FormFieldState field) {
                    dynamic value =
                        _formKey.currentState!.getRawValue('read') ??
                            field.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: value,
                              onChanged: (bool? newValue) {
                                _formKey.currentState?.fields['read']!
                                    .didChange(newValue);
                              },
                            ),
                            const Body1(
                              text: 'I have read this instruction',
                            ),
                          ],
                        ),
                        if (!_formKey.currentState!.isValid)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Body1(
                              text: 'You must confirm this',
                              color: Colors.red,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              spaceV15,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: SizedBox(
                  height: 35,
                  width: 135,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _formKey.currentState?.saveAndValidate();
                      if (_formKey.currentState!.isValid) {
                        String userGuId = authController.userGuId.value;
                        testController.generateSession(userGuId).then(
                          (sessionId) {
                            testController.takeTest(userGuId, sessionId).then(
                              (value) {
                                if (value != null) {
                                  Get.offNamed(
                                    "$routePath/$currentTestGuid",
                                  );
                                } else {
                                  Get.snackbar(
                                    "Success",
                                    'Unable to Start Test Session',
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade300,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Body1(
                      text: 'Continue',
                      color: white,
                    ),
                  ),
                ),
              ),
              spaceV30,
            ],
          ),
        ),
      ),
    );
  }
}
