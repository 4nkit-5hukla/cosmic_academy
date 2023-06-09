import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/form/form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class MCMC extends StatelessWidget {
  const MCMC({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Choice ${(index + 1)}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FormBuilderTextInputField(
          fieldName: "position[$index]",
          labelText: 'Position*',
          initialValue: (index + 1).toString(),
          isRequired: true,
        ),
        const SizedBox(
          height: 20,
        ),
        FormBuilderHtmlField(
          fieldName: "choice[$index]",
          hintText: "Your Choice...",
          isRequired: true,
        ),
        const SizedBox(
          height: 20,
        ),
        FormBuilderRadioGroup(
          name: 'correct_answer[$index]',
          orientation: OptionsOrientation.horizontal,
          initialValue: '0',
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(),
            ],
          ),
          options: const [
            FormBuilderFieldOption(
              value: "1",
              child: Text('Yes'),
            ),
            FormBuilderFieldOption(
              value: "0",
              child: Text('No'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Is Correct?',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        ),
      ],
    );
  }
}
