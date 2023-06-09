import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/view/navigator/student/quick_navigator.dart';
import 'package:cosmic_assessments/view/sidebar/student/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentTestReportPage extends StatefulWidget {
  const StudentTestReportPage({super.key});

  @override
  State<StudentTestReportPage> createState() => _StudentTestReportPageState();
}

class _StudentTestReportPageState extends State<StudentTestReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  String listing = 'summary';

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
        title: const Text(
          'Reports',
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
      drawer: StudentSidebar(),
      bottomNavigationBar: QuickNavigatorStudent(
        bottomNavigationController: bottomNavigationController,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          listing = 'summary';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: listing == 'summary'
                              ? secondary
                              : Theme.of(context).primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: const Body1(
                          text: "Summary",
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
                          listing = 'details';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: listing == 'details'
                              ? secondary
                              : Theme.of(context).primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: const Body1(
                          text: "Details",
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            spaceV20,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 30.0,
                  height: 75,
                  color: secondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Heading1(
                        text: '68',
                        color: white,
                      ),
                      spaceV5,
                      Body2(
                        text: 'Test Marks',
                        color: white,
                      ),
                    ],
                  ),
                ),
                spaceH20,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 30.0,
                  height: 75,
                  color: b2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Heading1(
                        text: '20',
                        color: white,
                      ),
                      spaceV5,
                      Body2(
                        text: 'Submissions',
                        color: white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            spaceV20,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 30.0,
                  height: 75,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Heading1(
                        text: '39',
                        color: white,
                      ),
                      spaceV5,
                      Body2(
                        text: 'Passed',
                        color: white,
                      ),
                    ],
                  ),
                ),
                spaceH20,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 30.0,
                  height: 75,
                  color: b1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Heading1(
                        text: '20',
                        color: white,
                      ),
                      spaceV5,
                      Body2(
                        text: 'Failed',
                        color: white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            spaceV20,
          ],
        ),
      ),
    );
  }
}
