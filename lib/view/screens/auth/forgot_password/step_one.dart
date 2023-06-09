import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class ForgotStepOne extends StatelessWidget {
  ForgotStepOne({
    Key? key,
  }) : super(key: key);

  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Spacer(flex: 5),
        Center(
          child: Image.asset(Img.get('sign_up.png')),
        ),
        spaceV20,
        const Heading1(
          text: "Forgotten Password?",
          color: onyx,
        ),
        spaceV30,
        if (authController.useMobile.value)
          Container(
            color: white,
            child: FormBuilderPhoneField(
              name: 'username',
              iconSelector: const SizedBox(width: 0),
              defaultSelectedCountryIsoCode: globalController.country.value,
              priorityListByIsoCode: [globalController.country.value],
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              keyboardType: TextInputType.number,
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
        if (!authController.useMobile.value)
          Container(
            color: white,
            child: FormBuilderTextField(
              name: 'username',
              keyboardType: TextInputType.text,
              contextMenuBuilder:
                  (BuildContext context, EditableTextState editableTextState) {
                final List<ContextMenuButtonItem> buttonItems =
                    editableTextState.contextMenuButtonItems;
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems: buttonItems,
                );
              },
              // enabled: false,
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
        spaceV30,
      ],
    );
  }
}
