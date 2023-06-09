import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/users/delete_confirm_dialog.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/users/user_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/models/user/user_role.dart';

class AdminEditUserPopup extends StatefulWidget {
  static String routeName = "/a/edit-user/:guid";
  static String routePath = "/a/edit-user";
  final String title;
  const AdminEditUserPopup({super.key, required this.title});

  @override
  State<AdminEditUserPopup> createState() => _AdminEditUserPopupState();
}

class _AdminEditUserPopupState extends State<AdminEditUserPopup> {
  final globalController = Get.find<GlobalController>();
  final userController = Get.put(UserController());

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FormBuilder(
        key: _formKey,
        onChanged: () {},
        initialValue: userController.currentUser.toMap(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'role',
                      initialValue: userController.currentUser.role,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'User Role',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      items: userRoles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role.replaceAll('_', ' ').capitalize!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  name: 'first_name',
                  decoration: const InputDecoration(
                    hintText: 'Enter First Name',
                    labelText: 'First Name*',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  name: 'middle_name',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Middle Name',
                    labelText: 'Middle Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  name: 'last_name',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Last Name',
                    labelText: 'Last Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderPhoneField(
                  name: 'mobile',
                  initialValue: "+${userController.currentUser.mobile}",
                  iconSelector: const SizedBox(width: 0),
                  priorityListByIsoCode: [
                    globalController.country.value,
                  ],
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Contact No*',
                    hintText: '##########',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  name: 'email',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                    hintText: 'Enter your email',
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            _formKey.currentState?.saveAndValidate();
                            final formData = _formKey.currentState!.value;
                            final Map<String, String> parsedFormData =
                                formData.map(
                              (key, value) => key == 'status'
                                  ? MapEntry(
                                      key,
                                      value!.value.toString(),
                                    )
                                  : key == 'mobile'
                                      ? MapEntry(
                                          key,
                                          value!
                                              .toString()
                                              .replaceFirst('+', ''),
                                        )
                                      : MapEntry(
                                          key,
                                          value == null
                                              ? ''
                                              : value!.toString(),
                                        ),
                            );
                            parsedFormData.removeWhere((key, value) =>
                                key == 'middle_name' && value.isEmpty);
                            FocusScope.of(context).unfocus();
                            // RegisterUser(formData);
                            await userController.addUpdateUser(parsedFormData);
                          },
                          child: const Text('Update'),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            Get.dialog(
                              const DeleteConfirmDialog(),
                            );
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
