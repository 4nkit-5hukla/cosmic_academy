import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/utils/get_file_type.dart';
import 'package:cosmic_assessments/common/widgets/tests/test_submit_dialog.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/common/widgets/audio_player.dart';
import 'package:cosmic_assessments/common/widgets/video_player.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_questions_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_controller.dart';
import 'package:cosmic_assessments/models/questions/choice.dart';
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/view/sidebar/student/sidebar.dart';
import 'package:cosmic_assessments/view/screens/student/tests/tests.dart';

class StudentTestRunScreen extends StatefulWidget {
  static String routeName = "/test/run/:guid";
  static String routePath = "/test/run";

  const StudentTestRunScreen({super.key});

  @override
  State<StudentTestRunScreen> createState() => _StudentTestRunScreenState();
}

class _StudentTestRunScreenState extends State<StudentTestRunScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final authController = Get.find<AuthController>();
  final testController = Get.find<StudentTestController>();
  final testQuestionsController = Get.put(TestQuestionsController());
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  TimerCountdown getTimer(int seconds) {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      endTime: DateTime.now().add(
        Duration(
          seconds: seconds,
        ),
      ),
      timeTextStyle: const TextStyle(
        color: white,
        fontSize: 12,
      ),
      colonsTextStyle: const TextStyle(
        color: white,
        fontSize: 12,
      ),
      onEnd: testController.testSessionId.value.isNotEmpty
          ? () => submitTest()
          : null,
    );
  }

  late TimerCountdown? timer;
  List<String> attempted = [];
  List<String> unAttempted = [];
  List<String> markedReview = [];

  void submitTest() {
    _formKey.currentState?.saveAndValidate();
    Map<String, dynamic> formData = _formKey.currentState!.value;
    Map<String, dynamic> nonNullMap = Map.fromEntries(
      formData.entries.where((entry) => entry.value != null),
    );
    final Map<String, String> parsedFormData = nonNullMap.map((key, value) {
      return MapEntry(
        key.toString(),
        value!.toString(),
      );
    });
    parsedFormData.addAll({
      "user_guid": authController.userGuId.value,
      'set_session': testController.testSessionId.value,
    });
    testController.submitTest(parsedFormData).then((value) {
      if (value != "") {
        Get.snackbar(
          "Success",
          value,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          colorText: Colors.white,
        );
      }
      Get.off(
        () => StudentBrowseTests(
          title: testController.currentTest.type == 'evaluated'
              ? 'Evaluated Tests'
              : testController.currentTest.type == 'practice'
                  ? 'Practice Tests'
                  : 'Quiz',
          useBack: true,
        ),
        routeName: StudentBrowseTests.routeName,
      );
    });
  }

  @override
  void initState() {
    testQuestionsController
        .currentTestGuid(testController.currentTestGuid.value);
    testQuestionsController.fetchTestQuestions(true, true).then((value) async {
      await testQuestionsController.startCachingAssets();
      if (testQuestionsController.isLoading.value == false) {
        int timeInMin =
            int.parse(testController.currentTest.settings.testDuration);
        timer = testController.currentTest.settings.showTimer == "true"
            ? getTimer(timeInMin * 60)
            : null;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    testController.questionIndex(0);
    testController.attemptId(0);
    testController.testSessionId("");
    testQuestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return testController.currentTest.settings.showTimer == "true" &&
                testController.testSessionId.value.isNotEmpty
            ? false
            : true;
      },
      child: Scaffold(
        backgroundColor: grey,
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          // leadingWidth: 0,
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            testController.currentTest.title,
          ),
        ),
        drawer: StudentSidebar(),
        endDrawer: Drawer(
          width: 250,
          child: Obx(
            () {
              if (testQuestionsController.isLoading.value == true) {
                return const Loader();
              } else {
                return TestRunDrawer(
                  testController: testController,
                  testQuestionsController: testQuestionsController,
                  scaffoldKey: _scaffoldKey,
                  attempted: attempted,
                  markedReview: markedReview,
                  unAttempted: unAttempted,
                );
              }
            },
          ),
        ),
        body: Obx(() {
          if (testQuestionsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (testQuestionsController.testQuestions.isNotEmpty) {
              int questionIndex = testController.questionIndex.value;
              int totalQuestions = testQuestionsController.getTotalQuestions();
              List<String> quesIds = testQuestionsController.testQuestions
                  .map((e) => e.id)
                  .toList();
              Question question =
                  testQuestionsController.getQuestionByIndex(questionIndex);
              File? questionAsset = testQuestionsController
                  .getQuestionAssetsByIndex(questionIndex);
              String questionType = question.questionType;
              String questionId = question.id;
              List<Choice>? questionChoices = question.choices;
              // List<String> allStrings = [
              //   ...attempted,
              //   ...unAttempted,
              //   ...markedReview
              // ];
              // List<String> union = allStrings.toSet().toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Body2(
                                  text: "Q${questionIndex + 1}",
                                  color: text2,
                                ),
                                const SizedBox(
                                  width: 16,
                                  height: 14,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: text2,
                                  ),
                                ),
                                const Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: text2,
                                ),
                                spaceH5,
                                if (testController.currentTest.settings
                                        .timePerQuestion.isNotEmpty &&
                                    testController.currentTest.settings
                                            .timePerQuestion !=
                                        '0')
                                  Body2(
                                    text:
                                        "Per Que : ${testController.currentTest.settings.timePerQuestion} sec",
                                    color: text2,
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                if (timer != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: white,
                                        ),
                                        spaceH10,
                                        timer!,
                                      ],
                                    ),
                                  ),
                                spaceH15,
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    _scaffoldKey.currentState?.openEndDrawer();
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.align_horizontal_right,
                                      color: white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          if (questionIndex > 0) {
                            testController.questionIndex(questionIndex - 1);
                            if (attempted.contains(questionId)) {
                              unAttempted.remove(questionId);
                            } else {
                              unAttempted.add(questionId);
                            }
                            setState(() {
                              unAttempted = unAttempted;
                            });
                          }
                        } else if (details.primaryVelocity! < 0) {
                          if (questionIndex < (totalQuestions - 1)) {
                            testController.questionIndex(questionIndex + 1);
                            if (attempted.contains(questionId)) {
                              unAttempted.remove(questionId);
                            } else {
                              unAttempted.add(questionId);
                            }
                            setState(() {
                              unAttempted = unAttempted;
                            });
                          }
                        }
                      },
                      child: ListView(
                        children: <Widget>[
                          if (question.parentQuestion != null) spaceV10,
                          if (question.parentQuestion != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: HtmlWidget(
                                question.parentQuestion!,
                                textStyle: const TextStyle(
                                  color: black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          spaceV10,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: HtmlWidget(
                              question.question,
                              textStyle: const TextStyle(
                                color: black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          spaceV10,
                          if (question.fileHash != null &&
                              getFileType(question.fileHash!) == 'Audio')
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: AudioPlayerWidget(
                                  audioUrl: questionAsset != null
                                      ? DeviceFileSource(questionAsset.path)
                                      : UrlSource(
                                          '${question.fileURLPath}${question.fileHash!}',
                                        ),
                                ),
                              ),
                            ),
                          if (question.fileHash != null &&
                              getFileType(question.fileHash!) == "Image")
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: questionAsset != null
                                  ? Image.file(questionAsset)
                                  : Image.network(
                                      '${question.fileURLPath}${question.fileHash!}',
                                    ),
                            ),
                          if (question.fileHash != null &&
                              getFileType(question.fileHash!) == "Video")
                            VideoPlayer(
                              videoUrl:
                                  '${question.fileURLPath}${question.fileHash!}',
                              videoFile: questionAsset,
                            ),
                          if (question.parentFileUrl != null &&
                              getFileType(question.parentFileUrl!) == 'Audio')
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: AudioPlayerWidget(
                                  audioUrl: UrlSource(
                                    question.parentFileUrl!,
                                  ),
                                ),
                              ),
                            ),
                          if (question.parentFileUrl != null &&
                              getFileType(question.parentFileUrl!) == "Image")
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Image.network(
                                question.parentFileUrl!,
                              ),
                            ),
                          if (question.parentFileUrl != null &&
                              getFileType(question.parentFileUrl!) == "Video")
                            VideoPlayer(
                              videoUrl: question.parentFileUrl!,
                            ),
                          FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: [
                                FormBuilderField(
                                  name: "answer[$questionId]",
                                  key: Key(
                                    UniqueKey().toString(),
                                  ),
                                  builder: (FormFieldState field) {
                                    dynamic value = _formKey.currentState!
                                            .getRawValue(
                                                'answer[$questionId]') ??
                                        field.value;
                                    return Column(
                                      children: questionChoices!
                                          .map(
                                            (choice) => questionType == 'mcmc'
                                                ? CheckboxListTile(
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    value: value != null
                                                        ? value.contains(choice
                                                                .choiceKey)
                                                            ? true
                                                            : false
                                                        : false,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 5,
                                                      vertical: 0,
                                                    ),
                                                    dense: true,
                                                    onChanged: (newValue) {
                                                      List<String?> selected;
                                                      if (value != null &&
                                                          value is String) {
                                                        selected =
                                                            value.split(', ');
                                                      } else if (value
                                                          is String) {
                                                        selected =
                                                            value.split(', ');
                                                      } else {
                                                        selected = [];
                                                      }
                                                      if (newValue!) {
                                                        selected.add(
                                                            choice.choiceKey);
                                                      } else {
                                                        selected.remove(
                                                            choice.choiceKey);
                                                      }
                                                      field.didChange(
                                                        selected.join(', '),
                                                      );
                                                      if (attempted.contains(
                                                          questionId)) {
                                                        attempted
                                                            .remove(questionId);
                                                      } else {
                                                        attempted
                                                            .add(questionId);
                                                      }
                                                      setState(() {
                                                        attempted = attempted;
                                                      });
                                                    },
                                                    activeColor: b2,
                                                    title: HtmlWidget(
                                                      choice.choice,
                                                      textStyle: TextStyle(
                                                        color: value != null &&
                                                                value ==
                                                                    choice
                                                                        .choiceKey
                                                            ? b2
                                                            : black,
                                                        fontSize: 15,
                                                        fontFamily: "Noto Sans",
                                                      ),
                                                    ),
                                                  )
                                                : questionType == 'tf'
                                                    ? RadioListTile(
                                                        value: choice.choiceKey,
                                                        groupValue: value,
                                                        onChanged: (newValue) {
                                                          field.didChange(
                                                            newValue,
                                                          );
                                                          if (attempted
                                                              .contains(
                                                                  questionId)) {
                                                            attempted.remove(
                                                                questionId);
                                                          } else {
                                                            attempted.add(
                                                                questionId);
                                                          }
                                                          setState(() {
                                                            attempted =
                                                                attempted;
                                                          });
                                                        },
                                                        controlAffinity:
                                                            ListTileControlAffinity
                                                                .leading,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0,
                                                        ),
                                                        dense: true,
                                                        activeColor: b2,
                                                        title: HtmlWidget(
                                                          choice.choice,
                                                          textStyle: TextStyle(
                                                            color: value !=
                                                                        null &&
                                                                    value ==
                                                                        choice
                                                                            .choiceKey
                                                                ? b2
                                                                : black,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "Noto Sans",
                                                          ),
                                                        ),
                                                      )
                                                    : questionType == 'la'
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              15,
                                                            ),
                                                            child: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                field.didChange(
                                                                  value,
                                                                );
                                                              },
                                                              maxLines: 5,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                hintText:
                                                                    'Enter your answer here...',
                                                                labelText:
                                                                    'Answer',
                                                                alignLabelWithHint:
                                                                    true,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                                fillColor:
                                                                    white,
                                                                focusColor:
                                                                    white,
                                                                hoverColor:
                                                                    white,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : spaceZero,
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: markedReview.contains(questionId),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 0,
                            ),
                            dense: true,
                            onChanged: (newValue) {
                              if (markedReview.contains(questionId)) {
                                markedReview.remove(questionId);
                              } else {
                                markedReview.add(questionId);
                              }
                              setState(() {
                                markedReview = markedReview;
                              });
                            },
                            activeColor: b1,
                            title: const Body1(
                              text: 'Visit Question Later (Mark for review)',
                              color: b1,
                            ),
                          ),
                          spaceV30,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: questionIndex == 0
                              ? null
                              : () {
                                  if (questionIndex >= 0) {
                                    testController
                                        .questionIndex(questionIndex - 1);
                                    if (attempted.contains(questionId)) {
                                      unAttempted.remove(questionId);
                                    } else {
                                      unAttempted.add(questionId);
                                    }
                                    setState(() {
                                      unAttempted = unAttempted;
                                    });
                                  }
                                },
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: white,
                          ),
                          child: const Body2(
                            text: 'Prev',
                          ),
                        ),
                        Column(
                          children: [
                            Body2(
                              text: "${(questionIndex + 1)}/$totalQuestions",
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton.icon(
                                onPressed: () async {
                                  for (var quesId in quesIds) {
                                    if (attempted.contains(quesId)) {
                                      unAttempted.remove(quesId);
                                    } else if (!unAttempted.contains(quesId)) {
                                      unAttempted.add(quesId);
                                    }
                                  }
                                  setState(() {
                                    unAttempted = unAttempted;
                                  });
                                  Get.dialog(
                                    TestSubmitDialog(
                                      onSubmit: submitTest,
                                      timer: timer,
                                      attemptCount: attempted.length,
                                      markedCount: markedReview.length,
                                      unAttemptCount: unAttempted.length,
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: white,
                                ),
                                icon: const Icon(
                                  Icons.save,
                                  size: 20,
                                ),
                                label: const Body2(
                                  text: 'Submit Test',
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: (questionIndex + 1) == totalQuestions
                              ? null
                              : () {
                                  if (questionIndex < totalQuestions) {
                                    testController
                                        .questionIndex(questionIndex + 1);
                                    if (attempted.contains(questionId)) {
                                      unAttempted.remove(questionId);
                                    } else {
                                      unAttempted.add(questionId);
                                    }
                                    setState(() {
                                      unAttempted = unAttempted;
                                    });
                                  }
                                },
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: white,
                          ),
                          child: const Body2(
                            text: 'Next',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'Test has no questions.',
                  style: TextStyle(fontSize: 25),
                ),
              );
            }
          }
        }),
      ),
    );
  }
}

class TestRunDrawer extends StatelessWidget {
  const TestRunDrawer({
    super.key,
    required this.testController,
    required this.testQuestionsController,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.attempted,
    required this.markedReview,
    required this.unAttempted,
  }) : _scaffoldKey = scaffoldKey;

  final StudentTestController testController;
  final TestQuestionsController testQuestionsController;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final List<String> attempted;
  final List<String> markedReview;
  final List<String> unAttempted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        spaceV10,
        spaceV30,
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Body1(
                text: testController.currentTest.title,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
        ),
        spaceV10,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 15,
              ),
              itemCount: testQuestionsController.getTotalQuestions(),
              itemBuilder: (BuildContext context, int index) {
                Question question =
                    testQuestionsController.getQuestionByIndex(index);
                String questionId = question.id;
                return InkWell(
                  highlightColor: Colors.transparent,
                  onTap: () {
                    testController.questionIndex(index);
                    _scaffoldKey.currentState?.closeEndDrawer();
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: attempted.contains(questionId)
                          ? markedReview.contains(questionId)
                              ? secondary
                              : b2
                          : unAttempted.contains(questionId)
                              ? markedReview.contains(questionId)
                                  ? secondary
                                  : Colors.red
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Body2(
                      text: '${index + 1}',
                      color: attempted.contains(questionId)
                          ? markedReview.contains(questionId)
                              ? black
                              : white
                          : unAttempted.contains(questionId)
                              ? markedReview.contains(questionId)
                                  ? black
                                  : white
                              : black,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
        ),
        spaceV10,
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Body1(
                  text: 'Legend',
                ),
              ),
              spaceV5,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  spaceH10,
                  Container(
                    width: 10,
                    height: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  spaceH10,
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Body2(
                      text: 'Not Attempted',
                    ),
                  ),
                  spaceH20,
                  Container(
                    width: 10,
                    height: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: b2,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  spaceH10,
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Body2(
                      text: 'Attempted',
                    ),
                  ),
                ],
              ),
              spaceV5,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  spaceH10,
                  Container(
                    width: 10,
                    height: 10,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  spaceH10,
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Body2(
                      text: 'Visit Later',
                    ),
                  ),
                ],
              ),
              spaceV20,
            ],
          ),
        )
      ],
    );
  }
}
