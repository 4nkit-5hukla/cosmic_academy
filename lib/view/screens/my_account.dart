import 'package:cosmic_assessments/common/widgets/form/form_builder_text_input_field.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/controllers/my_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class MyAccount extends StatefulWidget {
  static String routeName = "/my-account";
  final String title;
  const MyAccount({super.key, required this.title});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final myAccountController = Get.put(MyAccountController());
  final GlobalKey<FormBuilderState> _formKey1 = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _formKey2 = GlobalKey<FormBuilderState>();

  bool _obscurePW = true;
  bool _obscureCPW = true;
  bool showOnDate = false;

  @override
  Widget build(BuildContext context) {
    // print(testController.currentTest);
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Obx(
        () {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilder(
                  key: _formKey1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Heading3(
                            text: 'Update Info',
                          ),
                        ),
                        spaceV10,
                        const Heading4(text: 'First Name'),
                        spaceV5,
                        FormBuilderTextInputField(
                          fieldName: 'first_name',
                          hintText: 'Enter First Name',
                          labelText: '',
                          initialValue: authController.userFirstName!.value,
                          isRequired: true,
                        ),
                        spaceV10,
                        const Heading4(text: 'Middle Name'),
                        spaceV5,
                        FormBuilderTextInputField(
                          fieldName: 'middle_name',
                          hintText: 'Enter Middle Name',
                          labelText: '',
                          initialValue: authController.userMiddleName!.value,
                        ),
                        spaceV10,
                        const Heading4(text: 'Last Name'),
                        spaceV5,
                        FormBuilderTextInputField(
                          fieldName: 'last_name',
                          hintText: 'Enter Last Name',
                          labelText: '',
                          initialValue: authController.useLastName!.value,
                        ),
                        spaceV10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                _formKey1.currentState?.saveAndValidate();
                                final formData = _formKey1.currentState!.value;
                                final Map<String, String> parsedFormData =
                                    formData.map((key, value) {
                                  return MapEntry(
                                    key,
                                    value!.toString(),
                                  );
                                });
                                parsedFormData.removeWhere((key, value) =>
                                    key == 'middle_name' && value.isEmpty);
                                String reqMsg =
                                    await myAccountController.updateUser(
                                        parsedFormData,
                                        authController.userGuId.value);
                                Get.back();
                                if (reqMsg.isNotEmpty) {
                                  Get.snackbar(
                                    "Success",
                                    reqMsg,
                                    icon: const Icon(
                                      Icons.warning,
                                      color: Colors.white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: globalController.mainColor,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.save_outlined,
                              ),
                              label: const Body1(
                                text: 'Save',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                spaceV10,
                const Divider(
                  thickness: 1,
                  color: text2,
                ),
                spaceV10,
                FormBuilder(
                  key: _formKey2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Center(
                          child: Heading3(
                            text: 'Change Password',
                          ),
                        ),
                        spaceV10,
                        const Heading4(text: 'New Password'),
                        spaceV5,
                        Container(
                          color: white,
                          child: FormBuilderTextField(
                            name: 'password',
                            obscureText: _obscurePW,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePW
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePW = !_obscurePW;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: text2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            style: const TextStyle(
                              color: onyx,
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(8),
                              ],
                            ),
                          ),
                        ),
                        spaceV10,
                        const Heading4(text: 'Confirm Password'),
                        spaceV5,
                        Container(
                          color: white,
                          child: FormBuilderTextField(
                            name: 'password_confirm',
                            obscureText: _obscureCPW,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCPW
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureCPW = !_obscureCPW;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: text2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            style: const TextStyle(
                              color: onyx,
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(8),
                              ],
                            ),
                          ),
                        ),
                        spaceV10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                _formKey2.currentState?.saveAndValidate();
                                final formData = _formKey2.currentState!.value;
                                final Map<String, String> parsedFormData =
                                    formData.map((key, value) {
                                  return MapEntry(
                                    key,
                                    value!.toString(),
                                  );
                                });
                                String reqMsg =
                                    await myAccountController.changePassword(
                                        parsedFormData,
                                        authController.userGuId.value);
                                Get.back();
                                if (reqMsg.isNotEmpty) {
                                  Get.snackbar(
                                    "Success",
                                    reqMsg,
                                    icon: const Icon(
                                      Icons.warning,
                                      color: Colors.white,
                                    ),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: globalController.mainColor,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.save_outlined,
                              ),
                              label: const Body1(
                                text: 'Save',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
