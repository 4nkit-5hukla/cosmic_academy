import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';
import 'package:cosmic_assessments/view/screens/auth/forgot_password/step_one.dart';
import 'package:cosmic_assessments/view/screens/auth/forgot_password/step_three.dart';
import 'package:cosmic_assessments/view/screens/auth/forgot_password/step_two.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = "/forgot-password";
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final authController = Get.find<AuthController>();
  List<String> stepActionLabels = [
    "Send OTP",
    "Verify",
    "Save Changes",
  ];
  String getStepActionLabel(int step) {
    return stepActionLabels[step];
  }

  List<Widget> forgotSteps = [
    ForgotStepOne(),
    ForgotStepTwo(),
    const ForgotStepThree(),
  ];
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;

  void onPageViewChange(int nextPage) {
    page = nextPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Obx(
        () {
          return FormBuilder(
            key: authController.forgotFormKey,
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
                          controller: pageController,
                          children: forgotSteps,
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
                              forgotSteps.length,
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
                                        .forgotFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    authController.forgotFormKey.currentState!
                                        .save();
                                    final formData = authController
                                        .forgotFormKey.currentState!.value;
                                    final Map<String, String> userData =
                                        formData.map(
                                      (key, value) => MapEntry(
                                        key,
                                        value!.toString().replaceAll('+', ''),
                                      ),
                                    );
                                    authController
                                        .verifyMobile(userData)
                                        .then((value) {
                                      if (value) {
                                        pageController.nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                    break;
                                  case 1:
                                    final formData = authController
                                        .forgotFormKey.currentState!.value;
                                    Map<String, String> userData = formData.map(
                                      (key, value) => MapEntry(
                                        key,
                                        value!.toString().replaceAll('+', ''),
                                      ),
                                    );
                                    userData.addAll(
                                      {
                                        'otp': authController.forgotOTP.value,
                                      },
                                    );
                                    authController
                                        .verifyOTP(userData)
                                        .then((value) {
                                      if (value) {
                                        authController.forgotOTP('');
                                        pageController.nextPage(
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
                                        .forgotFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    authController.forgotFormKey.currentState!
                                        .save();
                                    final formData = authController
                                        .forgotFormKey.currentState!.value;
                                    final Map<String, String> userData =
                                        formData.map(
                                      (key, value) => key == 'username'
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
                                      'token': authController.forgotToken.value,
                                    });
                                    authController
                                        .changePassword(userData)
                                        .then((value) {
                                      if (value) {
                                        authController.forgotOTP('');
                                        authController.forgotToken('');
                                        authController
                                            .forgotFormKey.currentState!
                                            .reset();
                                        Get.offNamed(
                                          SignInScreen.routeName,
                                        );
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
                        pageController.previousPage(
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
