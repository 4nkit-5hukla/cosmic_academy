import 'package:cosmic_assessments/common/widgets/form/form_builder_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TrueFalse extends StatefulWidget {
  const TrueFalse({
    super.key,
    required this.formKey,
    required this.index,
    required this.value,
  });
  final GlobalKey<FormBuilderState> formKey;
  final int index;
  final String value;

  @override
  State<TrueFalse> createState() => _TrueFalseState();
}

class _TrueFalseState extends State<TrueFalse> {
  bool isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Choice ${(widget.index + 1)}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FormBuilderTextInputField(
          fieldName: "position[${widget.index}]",
          labelText: 'Position',
          initialValue: (widget.index + 1).toString(),
          isRequired: true,
        ),
        const SizedBox(
          height: 10,
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          value: isCorrect,
          title: const Text("Correct Choice"),
          onChanged: (bool? checked) {
            if (checked == true) {
              print(
                widget.formKey.currentState!
                    .fields['correct_answer[${widget.index}]'],
              );
              // widget.formKey.currentState!
              //     .fields['correct_answer[${widget.index}]']!
              //     .didChange('1');
              setState(() {
                isCorrect = true;
              });
            } else if (checked == false) {
              // widget.formKey.currentState!
              //     .fields['correct_answer[${widget.index}]']!
              //     .didChange('0');
              setState(() {
                isCorrect = false;
              });
            }
          },
        ),
        // FormBuilderCheckbox(
        //   name: 'correct_answer[${widget.index}]',
        //   initialValue: false,
        //   onChanged: (dynamic value) {},
        //   title: Text("Correct Choice ${widget.value}"),
        // ),
        const SizedBox(
          height: 10,
        ),
        FormBuilderTextInputField(
          fieldName: "choice[${widget.index}]",
          labelText: "Choice Label",
          isRequired: true,
          initialValue: widget.value.toString(),
        ),
      ],
    );
  }
}
