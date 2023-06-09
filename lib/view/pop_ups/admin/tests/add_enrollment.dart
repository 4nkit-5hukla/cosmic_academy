import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_enrollment_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_unenrollment_controller.dart';
import 'package:cosmic_assessments/models/tests/unenrolled.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';

class AdminAddEnrolmentPopUp extends StatefulWidget {
  static String routeName = "/a/add-enrollment";
  final String title;

  const AdminAddEnrolmentPopUp({super.key, required this.title});

  @override
  State<AdminAddEnrolmentPopUp> createState() => _AdminAddEnrolmentPopUpState();
}

class _AdminAddEnrolmentPopUpState extends State<AdminAddEnrolmentPopUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final testEnrollmentController = Get.find<AdminTestEnrollMentController>();
  final testUnEnrollmentController = Get.put(AdminTestUnEnrollMentController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  int stage = 1;
  List<String> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    testUnEnrollmentController
        .currentTestGuid(testController.currentTestGuid.value);
    if (testUnEnrollmentController.unEnrolledUsers.isEmpty) {
      testUnEnrollmentController.getUnEnrolledUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      drawer: AdminSidebar(),
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      body: Obx(
        () {
          if (testUnEnrollmentController.isLoading.value == true) {
            return const Loader();
          } else {
            if (stage == 1) {
              if (testUnEnrollmentController.unEnrolledUsers.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: testUnEnrollmentController.scrollController,
                        itemCount:
                            testUnEnrollmentController.unEnrolledUsers.length,
                        itemBuilder: (context, index) {
                          UnEnrolled unEnrolledUser =
                              testUnEnrollmentController.unEnrolledUsers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Card(
                              elevation: 0,
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value:
                                    selectedUsers.contains(unEnrolledUser.guid),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    spaceV5,
                                    Wrap(
                                      children: [
                                        Body1(
                                          text: '${index + 1}',
                                          color: black,
                                        ),
                                        spaceH5,
                                        Body1(
                                          text:
                                              "${unEnrolledUser.firstName} ${unEnrolledUser.lastName}",
                                          color: black,
                                        ),
                                      ],
                                    ),
                                    spaceV10,
                                    Body2(
                                      text: unEnrolledUser.guid,
                                      color: black,
                                    ),
                                    spaceV5,
                                  ],
                                ),
                                onChanged: (bool? checked) {
                                  if (checked == true) {
                                    selectedUsers.add(unEnrolledUser.guid);
                                  } else {
                                    selectedUsers.remove(unEnrolledUser.guid);
                                  }
                                  setState(() {
                                    selectedUsers = selectedUsers;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    spaceV20,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              onPressed: selectedUsers.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        stage = 2;
                                      });
                                    },
                              child: const Body1(
                                text: 'Next',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceV30,
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.find_in_page,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      Container(height: 15),
                      Text(
                        "No Users found.",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        const Heading4(text: 'Start Date'),
                        spaceV15,
                        FormBuilderDateTimePicker(
                          name: 'start_date',
                          decoration: InputDecoration(
                            filled: true,
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
                              FormBuilderValidators.required(),
                            ],
                          ),
                        ),
                        spaceV15,
                        const Heading4(text: 'End Date '),
                        spaceV15,
                        FormBuilderDateTimePicker(
                          name: 'end_date',
                          decoration: InputDecoration(
                            filled: true,
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
                              FormBuilderValidators.required(),
                            ],
                          ),
                        ),
                        spaceV20,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    _formKey.currentState?.saveAndValidate();
                                    // DateFormat('yyyy-MM-DD HH:mm:ss').format();
                                    Map<String, dynamic> formData =
                                        _formKey.currentState!.value;
                                    final Map<String, String> parsedFormData =
                                        formData.map((key, value) {
                                      return MapEntry(
                                        key,
                                        value!.toString(),
                                      );
                                    });
                                    Map<String, String> selectedUsersMap = {};
                                    for (int i = 0;
                                        i < selectedUsers.length;
                                        i++) {
                                      selectedUsersMap["users[$i]"] =
                                          selectedUsers[i];
                                    }
                                    parsedFormData.addAll(selectedUsersMap);
                                    await testEnrollmentController
                                        .enrollUsers(parsedFormData);
                                  },
                                  child: const Body1(
                                    text: 'Save',
                                    color: white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
