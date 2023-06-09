import 'package:cosmic_assessments/common/utils/generate_password.dart';
import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/common/widgets/timer_button.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ForgotStepThree extends StatefulWidget {
  const ForgotStepThree({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotStepThree> createState() => _ForgotStepThreeState();
}

class _ForgotStepThreeState extends State<ForgotStepThree> {
  final authController = Get.find<AuthController>();
  bool _obscureText = true;

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
          text: "Setup your new password",
          color: onyx,
        ),
        spaceV30,
        Container(
          color: white,
          child: FormBuilderTextField(
            name: 'password',
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter New Password',
              prefixIcon: const Icon(
                Icons.key_rounded,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Body2(
              text: "Generate Strong Password?",
              color: text2,
            ),
            spaceH5,
            TimerButton(
              label: 'Generate',
              seconds: 5,
              retryLabel: "Wait",
              onPressed: () async {
                String newPassword = generatePassword();
                Clipboard.setData(
                  ClipboardData(
                    text: newPassword,
                  ),
                ).then((void value) {
                  authController.signUpFormKey.currentState!.fields['password']!
                      .didChange(newPassword);
                  Get.snackbar(
                    "Your new password is copied",
                    'Secure password somewhere safe',
                    duration: const Duration(
                      seconds: 10,
                    ),
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.lightBlueAccent,
                    colorText: Colors.white,
                    borderRadius: 0,
                    margin: const EdgeInsets.all(
                      0,
                    ),
                  );
                });
              },
            ),
          ],
        ),
        spaceV30,
      ],
    );
  }
}
