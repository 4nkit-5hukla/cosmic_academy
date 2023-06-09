import 'package:cosmic_assessments/common/widgets/form/form_builder_drop_down_field.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';

import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';

class AdminEditTestPopUp extends StatefulWidget {
  static String routeName = "/a/edit-test/:guid";
  static String routePath = "/a/edit-test";
  final String title;

  const AdminEditTestPopUp({super.key, required this.title});

  @override
  State<AdminEditTestPopUp> createState() => _AdminEditTestPopUpState();
}

class _AdminEditTestPopUpState extends State<AdminEditTestPopUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final globalController = Get.find<GlobalController>();
  // final testController = Get.put(AdminTestController());
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  setLoading(bool state) => setState(
        () => isLoading = state,
      );

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
      body: FormBuilder(
        key: _formKey,
        initialValue: testController.currentTest.toMap(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
                const Heading4(text: 'Title'),
                spaceV15,
                FormBuilderTextInputField(
                  fieldName: 'title',
                  hintText: 'Enter Test Title',
                  labelText: '',
                  initialValue: testController.currentTest.title,
                  isRequired: true,
                ),
                spaceV15,
                const Heading4(text: 'Type'),
                spaceV20,
                FormBuilderDropDownField(
                  fieldName: 'type',
                  labelText: '',
                  initialValue: testController.currentTest.type,
                  isRequired: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'evaluated',
                      enabled: false,
                      child: Text(
                        'Evaluated',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'practice',
                      enabled: false,
                      child: Text(
                        'Practice',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'quiz',
                      enabled: false,
                      child: Text(
                        'Quiz',
                      ),
                    ),
                  ],
                ),
                spaceV15,
                const Heading4(text: 'Details'),
                spaceV20,
                const FormBuilderHtmlField(
                  fieldName: 'details',
                  hintText: 'Enter Test Details here...',
                  isRequired: true,
                ),
                FormBuilderField(
                  name: "created_by",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) {
                    //Empty widget
                    return const SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
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
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setLoading(true);
                                  _formKey.currentState?.saveAndValidate();
                                  final formData = _formKey.currentState!.value;
                                  final Map<String, String> parsedFormData =
                                      formData.map(
                                    (key, value) => MapEntry(
                                      key,
                                      value!.toString(),
                                    ),
                                  );
                                  FocusScope.of(context).unfocus();
                                  // RegisterUser(formData);
                                  String message = await testController
                                      .addUpdateTest(parsedFormData);
                                  Get.back();
                                  setLoading(false);
                                  if (message.isNotEmpty) {
                                    Get.snackbar(
                                      "Success",
                                      message,
                                      icon: const Icon(
                                        Icons.check,
                                        color: white,
                                      ),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          globalController.mainColor,
                                      colorText: white,
                                    );
                                  }
                                },
                          child: const Body1(
                            text: 'Update Test',
                            color: white,
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
