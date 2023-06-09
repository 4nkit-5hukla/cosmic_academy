import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormBuilderDropDownField extends StatefulWidget {
  const FormBuilderDropDownField({
    Key? key,
    required this.fieldName,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.isRequired = false,
    this.initialValue = "",
  }) : super(key: key);

  final String fieldName;
  final String labelText;
  final String initialValue;
  final List<DropdownMenuItem<String>> items;
  final bool isRequired;
  final void Function(String?)? onChanged;

  @override
  State<FormBuilderDropDownField> createState() =>
      _FormBuilderDropDownFieldState();
}

class _FormBuilderDropDownFieldState extends State<FormBuilderDropDownField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: FormBuilderDropdown<String>(
          name: widget.fieldName,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: -5.0,
              vertical: 10.0,
            ),
            labelText: widget.labelText,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade800,
              ),
              borderRadius: BorderRadius.circular(
                4,
              ),
            ),
          ),
          validator: widget.isRequired
              ? FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                )
              : null,
          items: widget.items,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
