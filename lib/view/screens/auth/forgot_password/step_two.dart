import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/common/widgets/timer_button.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';

class ForgotStepTwo extends StatelessWidget {
  ForgotStepTwo({
    Key? key,
  }) : super(key: key);

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Spacer(flex: 1),
        Center(
          child: Image.asset(Img.get('verify_mobile.png')),
        ),
        spaceV20,
        const Heading1(
          text: "Enter OTP",
          color: onyx,
        ),
        OtpTextField(
          numberOfFields: 5,
          focusedBorderColor: Theme.of(context).primaryColor,
          cursorColor: Theme.of(context).primaryColor,
          handleControllers: (controllers) {
            controllers.forEach((controller) {
              int index = controllers.indexOf(controller);
              controller?.text = authController.forgotOTP.value[index];
            });
          },
          // obscureText: true,
          textStyle: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ),
          onCodeChanged: (value) {
            authController.otp(value);
          },
          onSubmit: (String verificationCode) {
            authController.otp(verificationCode);
          },
        ),
        spaceV30,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Body2(
              text: "OTP Not Received?",
              color: text2,
            ),
            spaceH5,
            TimerButton(
              label: 'Resend',
              seconds: 30,
              onPressed: () async {
                final formData =
                    authController.forgotFormKey.currentState!.value;
                final Map<String, String> userData = formData.map(
                  (key, value) => MapEntry(
                    key,
                    value!.toString().replaceAll('+', ''),
                  ),
                );
                authController.verifyMobile(userData);
              },
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        spaceV15,
      ],
    );
  }
}
