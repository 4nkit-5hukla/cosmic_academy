import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/utils/generate_password.dart';
import 'package:cosmic_assessments/common/widgets/timer_button.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';

class SignUpStepThree extends StatefulWidget {
  const SignUpStepThree({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpStepThree> createState() => _SignUpStepThreeState();
}

class _SignUpStepThreeState extends State<SignUpStepThree> {
  final authController = Get.find<AuthController>();
  bool _obscureText = true;
  bool fieldFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Spacer(flex: 1),
        Center(
          child: Image.asset(Img.get('create_account.png')),
        ),
        const Heading1(
          text: "Provide Your Information",
          color: onyx,
        ),
        spaceV20,
        Container(
          color: white,
          child: FormBuilderTextField(
            contextMenuBuilder:
                (BuildContext context, EditableTextState editableTextState) {
              final List<ContextMenuButtonItem> buttonItems =
                  editableTextState.contextMenuButtonItems;
              return AdaptiveTextSelectionToolbar.buttonItems(
                anchors: editableTextState.contextMenuAnchors,
                buttonItems: buttonItems,
              );
            },
            name: 'email',
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: Icon(
                Icons.mail,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: text2,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
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
            onTap: () => setState(
              () => {fieldFocused = true},
            ),
            onSubmitted: (String? val) => setState(
              () => {fieldFocused = false},
            ),
          ),
        ),
        spaceV15,
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
            onTap: () => setState(
              () => {fieldFocused = true},
            ),
            onSubmitted: (String? val) => setState(
              () => {fieldFocused = false},
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
