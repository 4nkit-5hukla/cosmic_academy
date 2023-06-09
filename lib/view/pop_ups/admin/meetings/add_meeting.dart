import 'package:cosmic_assessments/common/widgets/form/form_builder_html_field.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/meetings/meeting_controller.dart';

class AdminAddMeeting extends StatefulWidget {
  static String routeName = "/a/add-test";
  final String title;
  const AdminAddMeeting({super.key, required this.title});

  @override
  State<AdminAddMeeting> createState() => _AdminAddMeetingState();
}

class _AdminAddMeetingState extends State<AdminAddMeeting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final meetingController = Get.put(MeetingController());
  final authController = Get.find<AuthController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

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
      body: FormBuilder(
        key: _formKey,
        initialValue: {
          'details': '',
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
                const FormBuilderHtmlField(
                  fieldName: 'details',
                  hintText: 'Enter Test Details here...',
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
                        width: 135,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
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
                            text: 'Create Meeting',
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
      ),
    );
  }
}
