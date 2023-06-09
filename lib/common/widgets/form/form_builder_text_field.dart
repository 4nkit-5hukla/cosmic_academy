import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class FormBuilderTextInputField extends StatelessWidget {
  const FormBuilderTextInputField({
    Key? key,
    required this.fieldName,
    this.hintText,
    this.labelText,
    this.initialValue = "",
    this.enabled = true,
    this.isRequired = false,
    this.isURL = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.minLength,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  final String fieldName;
  final String? hintText;
  final String? labelText;
  final String initialValue;
  final bool isRequired;
  final bool enabled;
  final bool isURL;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String?)? onChanged;
  final int maxLines;
  final int? minLines;
  final int? minLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String?>(
      name: fieldName,
      initialValue: initialValue,
      validator: FormBuilderValidators.compose(
        [
          if (isRequired) FormBuilderValidators.required(),
          if (minLength != null)
            FormBuilderValidators.minLength(
              minLength!,
            ),
          if (isURL) FormBuilderValidators.url(),
        ],
      ),
      builder: (FormFieldState field) {
        return TextField(
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
          ),
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          obscureText: obscureText,
          enabled: enabled,
          cursorColor: text1,
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: field.value ?? "",
              selection: TextSelection.collapsed(
                offset: field.value != null ? field.value.length ?? 0 : 0,
              ),
            ),
          ),
          onChanged: onChanged ?? (value) => field.didChange(value),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            filled: true,
            hintText: hintText,
            labelText: labelText,
            alignLabelWithHint: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: white,
            focusColor: white,
            hoverColor: white,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        );
      },
    );
  }
}
