import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class FormBuilderHtmlField extends StatefulWidget {
  const FormBuilderHtmlField({
    Key? key,
    required this.fieldName,
    required this.hintText,
    this.labelText = "",
    this.height = 150,
    this.isRequired = false,
    this.initialValue = "",
  }) : super(key: key);

  final String fieldName;
  final String labelText;
  final String hintText;
  final double height;
  final bool isRequired;
  final String initialValue;
  @override
  State<FormBuilderHtmlField> createState() => _FormBuilderHtmlFieldState();
}

class _FormBuilderHtmlFieldState extends State<FormBuilderHtmlField> {
  final HtmlEditorController controller = HtmlEditorController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String?>(
      name: widget.fieldName,
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.required(),
        ],
      ),
      builder: (FormFieldState field) {
        Key editorKey = Key(widget.fieldName);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != "")
              Text(
                widget.labelText,
              ),
            if (widget.labelText != "")
              const SizedBox(
                height: 5,
              ),
            HtmlEditor(
              key: editorKey,
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(
                hint: widget.hintText,
                shouldEnsureVisible: false,
                autoAdjustHeight: false,
                androidUseHybridComposition: false,
                adjustHeightForKeyboard: false,
                initialText: widget.initialValue != ''
                    ? widget.initialValue
                    : field.value,
              ),
              htmlToolbarOptions: const HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeScrollable,
                renderBorder: true,
                renderSeparatorWidget: true,
                defaultToolbarButtons: [
                  // FontSettingButtons(fontSizeUnit: false),
                  OtherButtons(fullscreen: false, help: false, codeview: false),
                  ColorButtons(),
                  FontButtons(
                    clearAll: false,
                    superscript: false,
                    subscript: false,
                  ),
                  ListButtons(listStyles: false),
                  InsertButtons(
                    video: false,
                    audio: false,
                    table: false,
                    hr: false,
                    otherFile: false,
                  ),
                ],
              ),
              otherOptions: OtherOptions(
                height: widget.height,
                decoration: BoxDecoration(
                  color: white,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Colors.grey.shade800,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      4,
                    ),
                  ),
                ),
              ),
              callbacks: Callbacks(
                onChangeContent: (String? value) => field.didChange(value),
              ),
            ),
            // if (!field.isValid && widget.isRequired)
            //   const Text(
            //     'This field is required',
            //     style: TextStyle(
            //       color: Colors.red,
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}
