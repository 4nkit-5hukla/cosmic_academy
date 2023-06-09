import 'dart:convert';

import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';

class AdminBulkUploadQuestions extends StatefulWidget {
  static String routeName = "/a/import-questions";
  final String title = "Import Questions";
  const AdminBulkUploadQuestions({super.key});

  @override
  State<AdminBulkUploadQuestions> createState() =>
      _AdminBulkUploadQuestionsState();
}

class _AdminBulkUploadQuestionsState extends State<AdminBulkUploadQuestions> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final String alpha = "ABCDEFGHIJKLMNOPQRSTUVBWXYZ";
  PlatformFile? file;
  int stage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
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
              color: white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      drawer: AdminSidebar(),
      body: Column(
        children: [
          if (stage == 1)
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceV25,
                    const Heading4(
                      text: 'Import Via Text File',
                    ),
                    spaceV10,
                    FormBuilderFilePicker(
                      name: 'file',
                      previewImages: false,
                      allowMultiple: false,
                      allowedExtensions: const [
                        'txt',
                      ],
                      typeSelectors: [
                        TypeSelector(
                          type: FileType.custom,
                          selector: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: text2,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.upload_rounded,
                              size: 32,
                              color: secondary,
                            ),
                          ),
                        ),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (List<PlatformFile>? files) {
                        if (files!.isNotEmpty) {
                          setState(() {
                            file = files.first;
                          });
                        }
                      },
                    ),
                    spaceV10,
                    SizedBox(
                      height: 35,
                      width: 180,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (file != null) {
                            testController
                                .bulkUploadQuestions(
                              authController.userGuId.value,
                              "userfile",
                              file!.path.toString(),
                            )
                                .then((value) {
                              setState(() {
                                stage = 2;
                              });
                              // Get.back();
                            });
                          }
                        },
                        child: const Text('Upload & Preview'),
                      ),
                    ),
                    spaceV10,
                    TextButton(
                      onPressed: () {},
                      child: const Body1(
                        text: 'Download sample file',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (stage == 2)
            Expanded(
              child: GetBuilder<AdminTestController>(
                builder: (controller) {
                  List<dynamic> uploadedQuestions =
                      controller.uploadedQuestions;
                  var items = uploadedQuestions.first.values.toList();
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      var question = item['question'];
                      var choice = item['choice'];
                      var correctAnswer = item['correct_answer'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Heading4(
                                      text: "${index + 1}. $question",
                                      color: text1,
                                    ),
                                    if (choice != null)
                                      ...choice.map((c) {
                                        // var idx =
                                        final idx = choice.indexOf(c);
                                        print(correctAnswer[idx].runtimeType);
                                        return Body1(
                                          text: "${alpha[idx]}. $c",
                                          color: correctAnswer[idx] == 1
                                              ? b2
                                              : text1,
                                        );
                                      }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          if (stage == 2)
            ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> jsonData = {
                    "questions": testController.uploadedQuestions.first,
                  };
                  Map<String, String> resultMap = {};
                  jsonData['questions'].forEach((key, value) {
                    resultMap['questions[$key][question]'] = value['question'];
                    resultMap['questions[$key][question_type]'] =
                        value['question_type'];

                    for (int i = 0; i < value['choice'].length; i++) {
                      resultMap['questions[$key][choice][$i]'] =
                          value['choice'][i];
                      resultMap['questions[$key][correct_answer][$i]'] =
                          value['correct_answer'][i].toString();
                      resultMap['questions[$key][order][$i]'] =
                          value['order'][i].toString();
                    }

                    resultMap['questions[$key][created_by]'] =
                        value['created_by'];
                  });
                  var message =
                      await testController.saveImportedQuestions(resultMap);
                  Get.back();
                  if (message.isNotEmpty) {
                    Get.snackbar(
                      "Success",
                      message,
                      icon: const Icon(
                        Icons.check,
                        color: white,
                      ),
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: white,
                      backgroundColor: globalController.mainColor,
                    );
                  }
                },
                child: const Body1(
                  text: 'Import Questions',
                ))
        ],
      ),
    );
  }
}
