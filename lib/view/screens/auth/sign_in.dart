import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/landing.dart';
import 'package:cosmic_assessments/view/screens/auth/forgot_password.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_up.dart';
import 'package:cosmic_assessments/view/screens/student/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign-in";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final storage = const FlutterSecureStorage();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: grey,
      body: Obx(() {
        return FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Center(
                    child: Image.asset(Img.get('sign_in.png')),
                  ),
                  spaceV20,
                  const Heading1(
                    text: "Sign in to get Started",
                    color: onyx,
                  ),
                  spaceV20,
                  if (authController.useMobile.value)
                    Container(
                      color: white,
                      child: FormBuilderPhoneField(
                        name: 'mobile',
                        iconSelector: const SizedBox(width: 0),
                        defaultSelectedCountryIsoCode:
                            globalController.country.value,
                        priorityListByIsoCode: [globalController.country.value],
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: text2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 6),
                          hintText: 'Mobile Number',
                        ),
                        style: const TextStyle(
                          color: onyx,
                        ),
                      ),
                    ),
                  if (authController.useMobile.value) spaceV20,
                  if (authController.useMobile.value)
                    const Center(child: Heading4(text: 'OR')),
                  if (authController.useMobile.value) spaceV20,
                  Container(
                    color: white,
                    child: FormBuilderTextField(
                      name: 'username',
                      keyboardType: TextInputType.text,
                      contextMenuBuilder: (BuildContext context,
                          EditableTextState editableTextState) {
                        final List<ContextMenuButtonItem> buttonItems =
                            editableTextState.contextMenuButtonItems;
                        return AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: editableTextState.contextMenuAnchors,
                          buttonItems: buttonItems,
                        );
                      },
                      decoration: const InputDecoration(
                        hintText: 'UserName Or Email',
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: text2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      style: const TextStyle(
                        color: onyx,
                      ),
                    ),
                  ),
                  spaceV20,
                  Container(
                    color: white,
                    child: FormBuilderTextField(
                      name: 'password',
                      obscureText: _obscureText,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.key_rounded,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: text2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  spaceV15,
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            Get.offNamed(ForgotPasswordScreen.routeName),
                        child: const Heading4(
                          text: "Forgot Password?",
                          color: text2,
                          bold: false,
                        ),
                      ),
                    ],
                  ),
                  spaceV15,
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: authController.isLoading.isTrue
                            ? text2
                            : Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: authController.isLoading.isTrue
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              final formData = _formKey.currentState!.value;
                              Map<String, dynamic> filteredFormData =
                                  Map.fromEntries(
                                formData.entries.where(
                                  (entry) => entry.value != null,
                                ),
                              );
                              filteredFormData.removeWhere(
                                (key, value) => value == null || value.isEmpty,
                              );
                              final Map<String, String> logInData =
                                  filteredFormData.map(
                                (key, value) => authController
                                            .useMobile.value &&
                                        key == 'mobile' &&
                                        value != null
                                    ? MapEntry(
                                        'username',
                                        value!.toString().replaceAll('+', ''),
                                      )
                                    : MapEntry(
                                        key,
                                        value!.toString(),
                                      ),
                              );
                              logInData.addAll({
                                "device_name":
                                    globalController.deviceName.value,
                              });
                              authController
                                  .logInUser(logInData)
                                  .then((bool value) {
                                if (value) {
                                  storage
                                      .write(
                                    key: 'token',
                                    value: globalController.token.value,
                                  )
                                      .then((value) {
                                    Get.offNamed(
                                      authController.userRole.value == "student"
                                          ? StudentLandingScreen.routeName
                                          : AdminLandingScreen.routeName,
                                    );
                                  });
                                }
                              });
                            },
                      child: authController.isLoading.isTrue
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                  spaceV10,
                  if (authController.allowUserRegistration.value)
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Heading4(
                            text: 'Don’t have any account?',
                            bold: false,
                            color: text2,
                          ),
                          spaceH5,
                          GestureDetector(
                            onTap: () => Get.offNamed(SignUpScreen.routeName),
                            child: Heading4(
                              text: "Sign Up",
                              bold: false,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  spaceV30,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
