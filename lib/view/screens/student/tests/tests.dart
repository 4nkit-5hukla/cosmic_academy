import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/tests/student_test_filter_dialog.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/test_controller.dart';
import 'package:cosmic_assessments/controllers/student/tests/tests_controller.dart';
import 'package:cosmic_assessments/models/tests/enrolled_test.dart';
import 'package:cosmic_assessments/models/tests/test.dart';
import 'package:cosmic_assessments/view/navigator/student/quick_navigator.dart';
import 'package:cosmic_assessments/view/screens/student/tests/quiz_run.dart';
import 'package:cosmic_assessments/view/screens/student/tests/start_test.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_submissions.dart';
import 'package:cosmic_assessments/view/sidebar/student/sidebar.dart';

class StudentBrowseTests extends StatefulWidget {
  static String routeName = "/tests";
  final String title;
  final bool useBack;
  const StudentBrowseTests({
    super.key,
    required this.title,
    required this.useBack,
  });
  @override
  State<StudentBrowseTests> createState() => _StudentBrowseTestsState();
}

class _StudentBrowseTestsState extends State<StudentBrowseTests> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final testsController = Get.find<StudentTestsController>();
  final testController = Get.put(StudentTestController());
  TextEditingController searchController = TextEditingController();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  bool showSearch = false;
  String listing = 'upcoming';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testsController.paginateTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: showSearch ? white : Theme.of(context).primaryColor,
        leading: showSearch
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: black,
                ),
                onPressed: () {
                  setState(() {
                    showSearch = false;
                  });
                  testsController.clearSearch();
                  testsController.clearFilters();
                  testsController.fetchTests();
                },
              )
            : widget.useBack
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  )
                : spaceZero,
        leadingWidth: showSearch
            ? 56
            : widget.useBack
                ? 56
                : 0,
        title: showSearch
            ? TextField(
                maxLines: 1,
                controller: searchController,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (term) {
                  testsController.search(searchController.text);
                  testsController.fetchTests();
                },
                onChanged: (term) {},
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 20.0),
                ),
              )
            : Text(
                widget.title,
              ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     color: showSearch ? black : white,
          //   ),
          //   onPressed: () => setState(
          //     () => {
          //       showSearch = true,
          //     },
          //   ),
          // ),
          IconButton(
            icon: Icon(
              Icons.filter_alt,
              color: showSearch ? black : white,
            ),
            onPressed: () => Get.dialog(
              StudentTestFilterDialog(),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              color: showSearch ? black : white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      drawer: StudentSidebar(),
      bottomNavigationBar: widget.useBack
          ? null
          : QuickNavigatorStudent(
              bottomNavigationController: bottomNavigationController,
            ),
      body: Obx(
        () {
          if (testsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (testsController.testsList.isNotEmpty &&
                testsController.testType.value != 'evaluated') {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spaceV15,
                  Expanded(
                    child: ListView.builder(
                      controller: testsController.scrollController,
                      itemCount: testsController.testsList.length,
                      itemBuilder: (context, index) {
                        Test test = testsController.testsList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Body2(
                                    text: test.guid,
                                    color: secondary,
                                  ),
                                  spaceV5,
                                  Body1(
                                    text: test.title,
                                    color: text1,
                                  ),
                                  spaceV5,
                                  Row(
                                    children: [
                                      const Body2(
                                        text: 'Date:',
                                        color: text1,
                                        bold: true,
                                      ),
                                      spaceH5,
                                      Body2(
                                        text: DateFormat('dd/MM/yyyy HH:mm a')
                                            .format(test.createdOn),
                                        color: text2,
                                      ),
                                    ],
                                  ),
                                  spaceV10,
                                  Row(
                                    children: [
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          testController
                                              .currentTestGuid(test.guid);
                                          testController
                                              .fetchTest()
                                              .then((value) {
                                            Get.toNamed(
                                              "${testsController.testType.value == "quiz" ? StudentQuizRunScreen.routePath : StudentStartTestScreen.routePath}/${test.guid}",
                                            );
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 35,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          alignment: Alignment.center,
                                          child: Body1(
                                            text: testsController
                                                        .testType.value ==
                                                    "quiz"
                                                ? "Start Quiz"
                                                : "Start Practice",
                                            color: white,
                                          ),
                                        ),
                                      ),
                                      spaceH10,
                                      if (testsController.testType.value ==
                                          "practice")
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            testController.currentTestGuid(
                                              test.guid,
                                            );
                                            testController.currentTest = test;
                                            Get.toNamed(
                                              "${StudentTestSubmissionsScreen.routePath}/${test.guid}",
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 35,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: b1,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Body1(
                                              text: "Result Test",
                                              color: white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (testsController.isNextLoading.value == true)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            } else if (testsController.enrolledTestsList.isNotEmpty &&
                testsController.testType.value == 'evaluated') {
              List<EnrolledTest> upComingTestsList =
                  testsController.getEnrolledTestsByListing("upcoming");
              List<EnrolledTest> onGoingTestsList =
                  testsController.getEnrolledTestsByListing("ongoing");
              List<EnrolledTest> previousTestsList =
                  testsController.getEnrolledTestsByListing("previous");
              List<EnrolledTest> currentTestsList =
                  testsController.getEnrolledTestsByListing(listing);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spaceV15,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        spaceH10,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                listing = 'upcoming';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: listing == 'upcoming'
                                    ? secondary
                                    : Theme.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Body1(
                                text: "Upcoming (${upComingTestsList.length})",
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        spaceH10,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                listing = 'ongoing';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: listing == 'ongoing'
                                    ? secondary
                                    : Theme.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Body1(
                                text: "Ongoing (${onGoingTestsList.length})",
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        spaceH10,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                listing = 'previous';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: listing == 'previous'
                                    ? secondary
                                    : Theme.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Body1(
                                text: "Previous (${previousTestsList.length})",
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        spaceH10,
                      ],
                    ),
                  ),
                  spaceV15,
                  if (currentTestsList.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentTestsList.length,
                        itemBuilder: (context, index) {
                          EnrolledTest enrolledTest = currentTestsList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Body2(
                                      text: enrolledTest.guid,
                                      color: secondary,
                                    ),
                                    spaceV5,
                                    Body1(
                                      text: enrolledTest.title,
                                      color: text1,
                                    ),
                                    spaceV5,
                                    if (testsController.testType.value ==
                                        'evaluated')
                                      Row(
                                        children: [
                                          const Body2(
                                            text: 'Start Date:',
                                            color: text1,
                                            bold: true,
                                          ),
                                          spaceH5,
                                          Body2(
                                            text: DateFormat(
                                                    'dd/MM/yyyy HH:mm a')
                                                .format(enrolledTest.startDate),
                                            color: text2,
                                          ),
                                        ],
                                      ),
                                    if (testsController.testType.value ==
                                        'evaluated')
                                      spaceV10,
                                    if (testsController.testType.value ==
                                        'evaluated')
                                      Row(
                                        children: [
                                          const Body2(
                                            text: 'End Date:',
                                            color: text1,
                                            bold: true,
                                          ),
                                          spaceH5,
                                          Body2(
                                            text: DateFormat(
                                                    'dd/MM/yyyy HH:mm a')
                                                .format(enrolledTest.endDate),
                                            color: text2,
                                          ),
                                        ],
                                      ),
                                    spaceV10,
                                    Row(
                                      children: [
                                        if (listing == 'ongoing')
                                          InkWell(
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              testController.currentTestGuid(
                                                  enrolledTest.guid);
                                              testController
                                                  .fetchTest()
                                                  .then((value) {
                                                Get.toNamed(
                                                  "${StudentStartTestScreen.routePath}/${enrolledTest.guid}",
                                                );
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 35,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Body1(
                                                text: "Start Test",
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        if (listing == 'previous')
                                          InkWell(
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              testController.currentTestGuid(
                                                enrolledTest.guid,
                                              );
                                              testController
                                                  .fetchTest()
                                                  .then((value) {
                                                Get.toNamed(
                                                  "${StudentTestSubmissionsScreen.routePath}/${enrolledTest.guid}",
                                                );
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 35,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: b1,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Body1(
                                                text: "See Reports",
                                                color: white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (currentTestsList.isEmpty)
                    Expanded(
                      flex: 1,
                      child: Center(
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
                              "No ${listing.capitalizeFirst} tests found.",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                      testsController.notFound[testsController.testType] ??
                          "No Tests found.",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
