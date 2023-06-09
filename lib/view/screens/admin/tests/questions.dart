import 'package:cosmic_assessments/common/utils/get_format_number.dart';
import 'package:cosmic_assessments/common/utils/get_time.dart';
import 'package:cosmic_assessments/common/utils/strip_html_tags.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/edit_question.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_questions_controller.dart';
import 'package:cosmic_assessments/models/questions/choice.dart';
import 'package:cosmic_assessments/models/questions/question.dart';

class AdminTestQuestionsScreen extends StatefulWidget {
  static String routeName = "/a/test/questions/:guid";
  static String routePath = "/a/test/questions";
  final String title;
  const AdminTestQuestionsScreen({super.key, required this.title});

  @override
  State<AdminTestQuestionsScreen> createState() =>
      _AdminTestQuestionsScreenState();
}

class _AdminTestQuestionsScreenState extends State<AdminTestQuestionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final globalController = Get.find<GlobalController>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<AdminTestController>();
  final testQuestionsController = Get.put(TestQuestionsController());
  bool showSearch = false;
  String search = '';
  List<String> selectedQuest = [];

  String getInitials({required String name}) {
    var buffer = StringBuffer();
    buffer.write(name[0] + name[1]);
    return buffer.toString().toUpperCase();
  }

  @override
  void initState() {
    // TODO: implement initState
    testQuestionsController
        .currentTestGuid(testController.currentTestGuid.value);
    testQuestionsController.fetchTestQuestions(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            widget.title,
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
        body: Obx(() {
          if (testQuestionsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (testQuestionsController.testQuestions.isNotEmpty) {
              Test test = testController.currentTest;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spaceV20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Heading3(text: test.title),
                          ),
                        ),
                        if (selectedQuest.isNotEmpty)
                          ElevatedButton(
                            onPressed: () async {
                              Map<String, String> quesData =
                                  selectedQuest.asMap().map((index, quesGuid) {
                                return MapEntry(
                                  "questions[$index]",
                                  quesGuid,
                                );
                              });
                              quesData.addAll({
                                'updated_by': authController.userGuId.value,
                              });
                              String message = await testQuestionsController
                                  .deleteTestQuestions(quesData);
                              testQuestionsController.fetchTestQuestions(true);
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
                              text: 'Delete',
                            ),
                          ),
                      ],
                    ),
                  ),
                  spaceV20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (test.settings.testDuration.isNotEmpty &&
                            test.settings.testDuration != '0')
                          Row(
                            children: [
                              const Body1(
                                text: 'Test Duration:',
                                bold: true,
                              ),
                              spaceH5,
                              Body1(
                                text: getTime(
                                  int.parse(
                                    test.settings.testDuration,
                                  ),
                                ),
                                color: text2,
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            const Body1(
                              text: 'Test Marks:',
                              bold: true,
                            ),
                            spaceH5,
                            Body1(
                              text:
                                  "${test.stats != null ? test.stats!.questions * int.parse(test.settings.marksPerQuestion) : "0"}",
                              color: text2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  spaceV20,
                  Expanded(
                    child: GetBuilder<TestQuestionsController>(
                      builder: (controller) {
                        List<Question> questions = controller.testQuestions;
                        return ListView.builder(
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            Question question = questions[index];
                            String quesId = question.guid;
                            String questionType = question.questionType;
                            List<Choice>? choices = question.choices;
                            return Column(
                              children: <Widget>[
                                Stack(
                                  children: [
                                    ListTile(
                                      // minVerticalPadding: 0,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      title: Container(
                                        padding: const EdgeInsets.only(
                                          left: 45,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => AdminEditQuestionPopUp(
                                                title: 'Edit Question',
                                                quesGuid: quesId,
                                              ),
                                              routeName: AdminEditQuestionPopUp
                                                  .routeName
                                                  .replaceFirst(
                                                      ':ques_guid', quesId),
                                              fullscreenDialog: true,
                                            );
                                          },
                                          child: Heading4(
                                            text: stripHtmlTags(
                                                "${(index + 1)}: ${question.question.replaceAll('&nbsp;', '_')}"),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      subtitle: Container(
                                        padding: const EdgeInsets.only(
                                          left: 45,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...?choices?.map((entry) {
                                              return Column(
                                                children: [
                                                  spaceV5,
                                                  Body1(
                                                    text:
                                                        '${getAlphaNumeral(choices.indexOf(entry))} ${stripHtmlTags(entry.choice.replaceAll('&nbsp;', ''))}',
                                                    color:
                                                        entry.correctAnswer ==
                                                                '1'
                                                            ? b2.shade900
                                                            : black,
                                                    bold: entry.correctAnswer ==
                                                        '1',
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                                      tileColor: selectedQuest.contains(quesId)
                                          ? Colors.grey.shade800
                                          : grey,
                                      selected: selectedQuest.contains(quesId),
                                      onLongPress: () {
                                        List<String> newSelQuest =
                                            selectedQuest;
                                        if (selectedQuest.contains(quesId)) {
                                          newSelQuest.add(quesId);
                                        } else {
                                          newSelQuest.remove(quesId);
                                        }
                                        setState(() {
                                          selectedQuest = newSelQuest;
                                        });
                                      },
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 5,
                                      child: Checkbox(
                                        visualDensity: VisualDensity(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        splashRadius: 30,
                                        value: selectedQuest.contains(quesId),
                                        onChanged: (value) {
                                          List<String> newSelQuest =
                                              selectedQuest;
                                          if (value == true) {
                                            newSelQuest.add(quesId);
                                          } else {
                                            newSelQuest.remove(quesId);
                                          }
                                          setState(() {
                                            selectedQuest = newSelQuest;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (index < questions.length)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    child: Divider(
                                      thickness: 2,
                                      color: white,
                                    ),
                                  )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'No Questions found.',
                  style: TextStyle(fontSize: 25),
                ),
              );
            }
          }
        }));
  }
}
