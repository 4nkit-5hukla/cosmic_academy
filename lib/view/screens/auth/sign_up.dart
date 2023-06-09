import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';

import 'package:cosmic_assessments/view/screens/auth/sign_up/step_four.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_up/step_one.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_up/step_three.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_up/step_two.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign-up";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authController = Get.find<AuthController>();
  List<String> stepActionLabels = [
    "Send OTP",
    "Verify",
    "Create Account",
    "Save & Login",
  ];

  String getStepActionLabel(int step) {
    return stepActionLabels[step];
  }

  List<Widget> signUpSteps = [
    SignUpStepOne(),
    const SignUpStepTwo(),
    const SignUpStepThree(),
    const SignUpStepFour(),
  ];

  int page = 0;

  void onPageViewChange(int nextPage) {
    page = nextPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: grey,
      body: Obx(
        () {
          return FormBuilder(
            key: authController.signUpFormKey,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overScroll) {
                          overScroll.disallowIndicator();
                          return true;
                        },
                        child: PageView(
                          onPageChanged: onPageViewChange,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: authController.signUpPageController,
                          children: signUpSteps,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        // height: 60,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              signUpSteps.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: page == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: page == index
                                      ? null
                                      : Border.all(
                                          color: text2,
                                          width: 1,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    spaceV30,
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
                                switch (page) {
                                  case 0:
                                    if (!authController
                                        .signUpFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    authController.signUpFormKey.currentState!
                                        .save();
                                    authController.sendOTP().then((value) {
                                      if (value) {
                                        authController.signUpPageController
                                            .nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                    break;
                                  case 1:
                                    authController.checkOTP().then((value) {
                                      if (value) {
                                        authController.signUpPageController
                                            .nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                    break;
                                  case 2:
                                    if (!authController
                                        .signUpFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    authController.signUpFormKey.currentState!
                                        .save();
                                    authController
                                        .continueSignUp()
                                        .then((value) {
                                      if (value) {
                                        authController.signUpPageController
                                            .nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                    break;
                                  case 3:
                                    if (!authController
                                        .signUpFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    final formData = authController
                                        .signUpFormKey.currentState!.value;
                                    final fullName =
                                        authController.userFullName.value;
                                    final userName =
                                        authController.userName.value;
                                    List<String> nameParts =
                                        fullName.split(" ");
                                    String firstName = nameParts[0];
                                    String lastName =
                                        nameParts[nameParts.length - 1];
                                    String middleName = nameParts.length > 2
                                        ? nameParts
                                            .sublist(1, nameParts.length - 1)
                                            .join(" ")
                                        : "";
                                    Map<String, String> userData = formData.map(
                                      (key, value) => key == 'mobile'
                                          ? MapEntry(
                                              key,
                                              value!
                                                  .toString()
                                                  .replaceAll('+', ''),
                                            )
                                          : MapEntry(
                                              key,
                                              value!.toString(),
                                            ),
                                    );
                                    userData.addAll({
                                      'first_name': firstName,
                                      if (middleName != '')
                                        'middle_name': middleName,
                                      'last_name': lastName,
                                      'username': userName,
                                    });
                                    authController
                                        .createAccount(userData)
                                        .then((value) {
                                      if (value) {
                                        Get.offNamed(
                                          SignInScreen.routeName,
                                        )!
                                            .then((value) {
                                          authController
                                              .signUpFormKey.currentState
                                              ?.reset();
                                        });
                                      }
                                    });
                                    break;
                                }
                              },
                        child: authController.isLoading.isTrue
                            ? const CircularProgressIndicator()
                            : Text(
                                getStepActionLabel(page),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                    spaceV10,
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Heading4(
                            text: 'Already a Member?',
                            bold: false,
                            color: text2,
                          ),
                          spaceH5,
                          GestureDetector(
                            onTap: () => Get.offNamed(SignInScreen.routeName),
                            child: Heading4(
                              text: "Sign In",
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
        },
      ),
      floatingActionButton: page > 0
          ? Column(
              children: [
                spaceV20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      child: const Icon(
                        Icons.west,
                        color: white,
                      ),
                      onPressed: () {
                        authController.signUpPageController.previousPage(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                    spaceH5
                  ],
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
