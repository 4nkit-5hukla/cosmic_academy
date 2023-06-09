import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:cosmic_assessments/common/utils/generate_password.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/users/user_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/models/user/user_role.dart';

class AdminAddNewUserPopup extends StatefulWidget {
  static String routeName = '/a/add-user';
  final String title;

  const AdminAddNewUserPopup({super.key, required this.title});

  @override
  State<AdminAddNewUserPopup> createState() => _AdminAddNewUserPopupState();
}

class _AdminAddNewUserPopupState extends State<AdminAddNewUserPopup> {
  final globalController = Get.find<GlobalController>();
  final userController = Get.put(UserController());

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // List of items in our dropdown menu
  String defaultRole = student.value;

  UserStatus defaultStatus = enable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: {
          'role': defaultRole,
          'status': defaultStatus,
          'first_name': '',
          'middle_name': '',
          'last_name': '',
          'password': generatePassword(),
          'mobile': '',
          'email': '',
        },
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
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: FormBuilderDropdown<UserStatus>(
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'status',
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 16.0,
                        ),
                        labelText: 'Status',
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
                      items: userStatus.map((UserStatus uStatus) {
                        return DropdownMenuItem<UserStatus>(
                          value: uStatus,
                          child: Text(uStatus.label),
                        );
                      }).toList(),
                      onChanged: (UserStatus? newValue1) {},
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
                  iconSelector: const SizedBox(width: 0),
                  defaultSelectedCountryIsoCode: globalController.country.value,
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
                  name: 'username',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName',
                    hintText: 'Enter UserName',
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
                FormBuilderField(
                  name: "password",
                  enabled: false,
                  builder: (FormFieldState<dynamic> field) {
                    if (isDebug) {
                      print(field.value);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            _formKey.currentState?.saveAndValidate();
                            final formData = _formKey.currentState!.value;
                            final Map<String, String> parsedFormData =
                                formData.map((key, value) {
                              return key == 'status'
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
                                          value!.toString(),
                                        );
                            });
                            parsedFormData.removeWhere((key, value) =>
                                key == 'middle_name' && value.isEmpty);
                            FocusScope.of(context).unfocus();
                            userController.addUpdateUser(parsedFormData);
                          },
                          child: const Text('Save'),
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
