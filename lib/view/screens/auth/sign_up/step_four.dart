import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';

class SignUpStepFour extends StatefulWidget {
  const SignUpStepFour({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpStepFour> createState() => _SignUpStepFourState();
}

class _SignUpStepFourState extends State<SignUpStepFour> {
  final authController = Get.find<AuthController>();
  String fullName = '';
  bool fieldFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fieldFocused ? grey : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: fieldFocused ? 150 : null,
              height: fieldFocused ? 150 : null,
              child: Image.asset(Img.get(
                'create_account.png',
              )),
            ),
          ),
          spaceV20,
          const Heading1(
            text: "Provide Your Details",
            color: onyx,
          ),
          spaceV20,
          Container(
            color: white,
            child: Focus(
              onFocusChange: (hasFocus) => setState(
                () => {fieldFocused = hasFocus},
              ),
              child: FormBuilderTextField(
                contextMenuBuilder: (BuildContext context,
                    EditableTextState editableTextState) {
                  final List<ContextMenuButtonItem> buttonItems =
                      editableTextState.contextMenuButtonItems;
                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: editableTextState.contextMenuAnchors,
                    buttonItems: buttonItems,
                  );
                },
                name: 'fullName',
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Enter full name',
                  prefixIcon: Icon(
                    Icons.medical_information_outlined,
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
                  ],
                ),
                onChanged: (value) {
                  authController.userFullName(value);
                },
                onSubmitted: (String? val) => setState(
                  () => {fieldFocused = false},
                ),
              ),
            ),
          ),
          if (!authController.autoGenerateUserName.value) spaceV20,
          if (!authController.autoGenerateUserName.value)
            Container(
              color: white,
              child: Focus(
                onFocusChange: (hasFocus) => setState(
                  () => {fieldFocused = hasFocus},
                ),
                child: FormBuilderTextField(
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  name: 'username',
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter UserName',
                    prefixIcon: Icon(
                      Icons.person,
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
                    ],
                  ),
                  onChanged: (value) {
                    authController.userName(value);
                  },
                  onSubmitted: (String? val) => setState(
                    () => {fieldFocused = false},
                  ),
                ),
              ),
            ),
          spaceV10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Body2(
                text: "I'll do this later?",
                color: text2,
              ),
              spaceH5,
              GestureDetector(
                onTap: () async {
                  final formData =
                      authController.signUpFormKey.currentState!.value;
                  final Map<String, String> userData = formData.map(
                    (key, value) => key == 'mobile'
                        ? MapEntry(
                            key,
                            value!.toString().replaceAll('+', ''),
                          )
                        : MapEntry(
                            key,
                            value!.toString(),
                          ),
                  );
                  authController.createAccount(userData).then((value) {
                    if (value) {
                      Get.offNamed(
                        SignInScreen.routeName,
                      )!
                          .then((value) {
                        authController.signUpFormKey.currentState!.reset();
                      });
                    }
                  });
                },
                child: Body2(
                  text: 'Skip',
                  bold: true,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          spaceV30,
        ],
      ),
    );
  }
}
