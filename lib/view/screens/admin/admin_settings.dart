import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/controllers/admin/admin_settings_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

// import 'package:cosmic_assessments/view/screens/edit_user.dart';

class AdminSettings extends StatefulWidget {
  static String routeName = "/a/settings";
  final String title = "Settings";
  const AdminSettings({super.key});
  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings>
    with SingleTickerProviderStateMixin {
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final adminSettingsController = Get.put(AdminSettingsController());
  final GlobalKey<FormBuilderState> _formKey1 = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _formKey2 = GlobalKey<FormBuilderState>();
  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Theme',
    ),
    Tab(
      text: 'Registration',
    ),
  ];
  late TabController _tabController;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  List<String> userRoles = [admin.value, teacher.value, student.value];

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      pickerColor = globalController.mainColor;
      currentColor = globalController.mainColor;
    });
    adminSettingsController.getTheme();
    adminSettingsController.getCommon();
    adminSettingsController.getFields();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
    // _tabController.addListener(onTap);
  }

  Dialog colorPickerDialog() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Heading4(
                  text: 'Please Select Color',
                ),
              ],
            ),
            spaceV10,
            ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              enableAlpha: false,
              paletteType: PaletteType.hsv,
            ),
            spaceV10,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentColor = pickerColor;
                    });
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        globalController.mainColor),
                    foregroundColor:
                        const MaterialStatePropertyAll<Color>(white),
                  ),
                  child: const Text('Ok'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          // isScrollable: true,
          tabs: myTabs,
        ),
      ),
      body: Obx(
        () {
          if (adminSettingsController.isLoading.value == true) {
            return const Loader();
          } else {
            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: myTabs.map((Tab tab) {
                final index = myTabs.indexOf(tab);
                if (index == 0) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          spaceV10,
                          const Heading4(
                            text: 'Change accent color',
                          ),
                          spaceV10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Body1(
                                text: 'Select Color',
                                bold: true,
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    colorPickerDialog(),
                                  );
                                },
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.square_sharp,
                                  color: currentColor,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                          spaceV10,
                          ElevatedButton.icon(
                            onPressed: () async {
                              String message =
                                  await adminSettingsController.saveTheme(
                                currentColor.toString(),
                                authController.userGuId.value,
                              );
                              Get.back();
                              if (message.isNotEmpty) {
                                Get.snackbar(
                                  "Success",
                                  message,
                                  icon: const Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                  ),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: globalController.mainColor,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.save_outlined,
                            ),
                            label: const Body1(
                              text: 'Save',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilder(
                          key: _formKey2,
                          initialValue: {
                            'created_by': authController.userGuId.value,
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Heading3(
                                    text: 'Common Settings',
                                  ),
                                ),
                                spaceV10,
                                const Divider(
                                  thickness: 1,
                                  color: grey,
                                ),
                                spaceV10,
                                const Heading4(text: 'Allow User Registration'),
                                FormBuilderCheckbox(
                                  name: 'allow_user_registration',
                                  initialValue: adminSettingsController
                                      .allowUserRegistration.value,
                                  title: const Text(
                                    "Toggle Allow User Registration",
                                  ),
                                ),
                                spaceV10,
                                const Heading4(text: 'Auto Generate UserName'),
                                FormBuilderCheckbox(
                                  name: 'auto_generate_username',
                                  initialValue: adminSettingsController
                                      .autoGenerateUsername.value,
                                  title: const Text(
                                    "Toggle Auto Generate UserName",
                                  ),
                                ),
                                const Heading4(text: 'Default Role'),
                                spaceV10,
                                DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: FormBuilderDropdown<String>(
                                      // autovalidate: true,
                                      initialValue: adminSettingsController
                                          .defaultUserRole.value,
                                      name: 'default_user_role',
                                      decoration: InputDecoration(
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                          child: Text(role.capitalizeFirst!),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {},
                                    ),
                                  ),
                                ),
                                spaceV20,
                                const Heading4(text: 'Auto Approve'),
                                FormBuilderCheckbox(
                                  name: 'auto_approve_user',
                                  initialValue: adminSettingsController
                                      .autoApproveUser.value,
                                  onChanged: (dynamic value) {},
                                  title: const Text(
                                    "Toggle Auto Approve",
                                  ),
                                ),
                                spaceV10,
                                FormBuilderField(
                                  name: "created_by",
                                  enabled: false,
                                  builder: (FormFieldState<dynamic> field) =>
                                      spaceZero,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        _formKey2.currentState
                                            ?.saveAndValidate();
                                        final formData =
                                            _formKey2.currentState!.value;
                                        final Map<String, String>
                                            parsedFormData =
                                            formData.map((key, value) {
                                          return MapEntry(
                                            key,
                                            value!.toString(),
                                          );
                                        });
                                        String reqMsg =
                                            await adminSettingsController
                                                .saveCommon(parsedFormData);
                                        Get.back();
                                        if (reqMsg.isNotEmpty) {
                                          Get.snackbar(
                                            "Success",
                                            reqMsg,
                                            icon: const Icon(
                                              Icons.warning,
                                              color: Colors.white,
                                            ),
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor:
                                                globalController.mainColor,
                                            colorText: Colors.white,
                                          );
                                          await authController.getCommon();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.save_outlined,
                                      ),
                                      label: const Body1(
                                        text: 'Save',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        spaceV10,
                        const Divider(
                          thickness: 1,
                          color: text2,
                        ),
                        spaceV10,
                        FormBuilder(
                          key: _formKey1,
                          initialValue: {
                            'created_by': authController.userGuId.value,
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Center(
                                  child: Heading3(
                                    text: 'Registration Fields',
                                  ),
                                ),
                                spaceV10,
                                const Divider(
                                  thickness: 1,
                                  color: grey,
                                ),
                                spaceV10,
                                const Heading4(text: 'Use Mobile No Field'),
                                FormBuilderCheckbox(
                                  name: 'fields[mobile]',
                                  initialValue:
                                      adminSettingsController.mobile.value,
                                  title: const Text(
                                    "Toggle Mobile No Field",
                                  ),
                                ),
                                spaceV10,
                                const Heading4(text: 'Use Email Field'),
                                FormBuilderCheckbox(
                                  name: 'fields[email]',
                                  initialValue:
                                      adminSettingsController.email.value,
                                  title: const Text(
                                    "Toggle Email Field",
                                  ),
                                ),
                                FormBuilderField(
                                  name: "created_by",
                                  enabled: false,
                                  builder: (FormFieldState<dynamic> field) =>
                                      spaceZero,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        _formKey1.currentState
                                            ?.saveAndValidate();
                                        final formData =
                                            _formKey1.currentState!.value;
                                        final Map<String, String>
                                            parsedFormData =
                                            formData.map((key, value) {
                                          return MapEntry(
                                            key,
                                            value!.toString(),
                                          );
                                        });
                                        String message =
                                            await adminSettingsController
                                                .saveFields(parsedFormData);
                                        bool msgCondition =
                                            (message.contains("Failed") ||
                                                message.contains("Wrong"));
                                        if (!msgCondition) {
                                          Get.back();
                                        }
                                        if (message.isNotEmpty) {
                                          Get.snackbar(
                                            msgCondition ? "Error" : "Success",
                                            message,
                                            icon: const Icon(
                                              Icons.warning,
                                              color: Colors.white,
                                            ),
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: msgCondition
                                                ? Colors.red
                                                : globalController.mainColor,
                                            colorText: Colors.white,
                                          );
                                          if (!msgCondition) {
                                            await authController.getFields();
                                          }
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.save_outlined,
                                      ),
                                      label: const Body1(
                                        text: 'Save',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
