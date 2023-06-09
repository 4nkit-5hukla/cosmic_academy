import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/models/meetings/meeting.dart';
import 'package:cosmic_assessments/view/navigator/student/quick_navigator.dart';
import 'package:cosmic_assessments/view/sidebar/student/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class StudentMeetingsList extends StatefulWidget {
  static String routeName = "/meetings";
  final String title;
  final bool useBack;
  const StudentMeetingsList({
    super.key,
    required this.title,
    this.useBack = false,
  });

  @override
  State<StudentMeetingsList> createState() => _StudentMeetingsListState();
}

class _StudentMeetingsListState extends State<StudentMeetingsList> {
  final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bNC = Get.find<BottomNavigationController>();
  final meetingsController = Get.find<MeetingsController>();
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;

  String findFirstUrl(String htmlString) {
    RegExp urlRegExp = RegExp(r'https?://\S+', caseSensitive: false);
    Iterable<Match> matches = urlRegExp.allMatches(htmlString);
    List<String> urls = [];
    for (Match match in matches) {
      urls.add(match.group(0)!);
    }
    return urls.isNotEmpty ? urls.first : "";
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launcher.launch(
      url,
      useSafariVC: false,
      useWebView: false,
      enableJavaScript: false,
      enableDomStorage: false,
      universalLinksOnly: false,
      headers: <String, String>{},
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: widget.useBack
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  meetingsController.usersMeetingsList.clear();
                  Get.back();
                },
              )
            : spaceZero,
        leadingWidth: widget.useBack ? 56 : 0,
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
          ),
        ],
      ),
      bottomNavigationBar: widget.useBack
          ? null
          : QuickNavigatorStudent(
              bottomNavigationController: bNC,
            ),
      drawer: StudentSidebar(),
      body: Obx(
        () {
          if (meetingsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (meetingsController.usersMeetingsList.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: meetingsController.usersMeetingsList.length,
                      itemBuilder: (context, index) {
                        Meeting meeting =
                            meetingsController.usersMeetingsList[index];
                        String meetingUrl =
                            findFirstUrl(meeting.details).trim();
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Body1(
                                            text: "Meeting ID:",
                                            color: text1,
                                            bold: true,
                                          ),
                                          spaceH5,
                                          Body1(
                                            text: meeting.guid,
                                            color: text1,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Body1(
                                            text: 'Date:',
                                            color: text1,
                                            bold: true,
                                          ),
                                          spaceH5,
                                          Body1(
                                            text: DateFormat('dd/MM/yyyy')
                                                .format(meeting.createdOn),
                                            color: text2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  spaceV10,
                                  Wrap(
                                    children: [
                                      HtmlWidget(
                                        meeting.details,
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  spaceV5,
                                  Row(
                                    children: [
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          _launchInBrowser(meetingUrl);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Body1(
                                            text: "Join",
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
                  if (meetingsController.isNextLoading.value == true)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
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
                      "No Meetings found.",
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
