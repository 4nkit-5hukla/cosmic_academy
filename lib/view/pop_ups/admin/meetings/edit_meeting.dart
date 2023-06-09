import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/meetings/meeting_controller.dart';

class AdminEditMeeting extends StatefulWidget {
  static String routeName = "/a/edit-meeting/:guid";
  static String routePath = "/a/edit-meeting";
  final String title;
  final String meetingGuid;
  const AdminEditMeeting(
      {super.key, required this.title, required this.meetingGuid});

  @override
  State<AdminEditMeeting> createState() => _AdminEditMeetingState();
}

class _AdminEditMeetingState extends State<AdminEditMeeting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final meetingController = Get.put(MeetingController());
  final authController = Get.find<AuthController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    meetingController.currentMeetingGuid(widget.meetingGuid);
    meetingController.fetchMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      drawer: AdminSidebar(),
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      body: Obx(
        () {
          if (meetingController.isLoading.value == false) {
            return FormBuilder(
              key: _formKey,
              initialValue: {
                'details': meetingController.currentMeeting.details,
                'created_by': authController.userGuId.value,
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      spaceV15,
                      const Heading4(
                        text: 'Meeting Details',
                      ),
                      spaceV20,
                      FormBuilderHtmlField(
                        fieldName: 'details',
                        hintText: 'Enter Test Details here...',
                        initialValue: meetingController.currentMeeting.details,
                        isRequired: true,
                        height: 300,
                      ),
                      FormBuilderField(
                        name: "created_by",
                        enabled: false,
                        builder: (FormFieldState<dynamic> field) {
                          //Empty widget
                          return const SizedBox.shrink();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 35,
                              width: 160,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  _formKey.currentState?.saveAndValidate();
                                  final formData = _formKey.currentState!.value;
                                  final Map<String, String> parsedFormData =
                                      formData.map(
                                    (key, value) => MapEntry(
                                      key,
                                      value!.toString(),
                                    ),
                                  );
                                  FocusScope.of(context).unfocus();
                                  meetingController
                                      .addUpdateMeeting(parsedFormData)
                                      .then((value) {
                                    Get.back();
                                  });
                                },
                                child: const Body1(
                                  text: 'Update Meeting',
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
          } else {
            return const Loader();
          }
        },
      ),
    );
  }
}
