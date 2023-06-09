import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormBuilderTextInputField extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: fieldName,
      keyboardType: keyboardType,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      obscureText: obscureText,
      initialValue: initialValue,
      enabled: enabled,
      cursorColor: text1,
      contextMenuBuilder:
          (BuildContext context, EditableTextState editableTextState) {
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
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
    );
  }
}
