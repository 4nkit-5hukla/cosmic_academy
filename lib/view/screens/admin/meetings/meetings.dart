import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/meetings/add_meeting.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/meetings/delete_meeting_confirm.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/meetings/edit_meeting.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/share_meeting.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/models/meetings/meeting.dart';
import 'package:cosmic_assessments/view/navigator/admin/quick_navigator.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';

class AdminMeetingsList extends StatefulWidget {
  static String routeName = "/a/meetings";
  final String title;
  final bool useBack;
  const AdminMeetingsList({
    super.key,
    required this.title,
    this.useBack = true,
  });

  @override
  State<AdminMeetingsList> createState() => _AdminMeetingsListState();
}

class _AdminMeetingsListState extends State<AdminMeetingsList> {
  final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bNC = Get.find<BottomNavigationController>();
  final meetingsController = Get.find<MeetingsController>();
  TextEditingController searchController = TextEditingController();

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
                onPressed: () => Get.back(),
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
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),
      bottomNavigationBar: widget.useBack
          ? null
          : QuickNavigatorAdmin(
              bottomNavigationController: bNC,
            ),
      drawer: AdminSidebar(),
      body: Obx(
        () {
          if (meetingsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (meetingsController.meetingsList.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spaceV15,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => const AdminAddMeeting(
                                title: 'Create Meeting',
                              ),
                              routeName: AdminAddMeeting.routeName,
                              fullscreenDialog: true,
                            );
                          },
                          child: const Heading3(
                            text: 'New Meeting',
                            bold: false,
                          ),
                        ),
                        // PopupMenuButton<String>(
                        //   icon: const Icon(
                        //     Icons.more_vert,
                        //     color: text1,
                        //   ),
                        //   onSelected: (String value) {},
                        //   itemBuilder: (context) => [],
                        // ),
                      ],
                    ),
                  ),
                  spaceV15,
                  Expanded(
                    child: ListView.builder(
                      itemCount: meetingsController.meetingsList.length,
                      itemBuilder: (context, index) {
                        Meeting meeting =
                            meetingsController.meetingsList[index];
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
                                      Body1(
                                        text: "Meeting ID: ${meeting.guid}",
                                        color: black,
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
                                  Wrap(
                                    direction: Axis.horizontal,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          meetingsController.currentMeeting =
                                              meeting;
                                          Get.to(
                                            () => AdminEditMeeting(
                                              title: 'Edit Meeting',
                                              meetingGuid: meeting.guid,
                                            ),
                                            routeName:
                                                "${AdminEditMeeting.routePath}/${meeting.guid}",
                                            fullscreenDialog: true,
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.edit_document,
                                              size: 14,
                                              color: text2,
                                            ),
                                            spaceH5,
                                            Body1(
                                              text: 'Edit',
                                              color: text2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                        height: 14,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: text1,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.dialog(
                                            DeleteMeetingConfirm(
                                              meetingGuid: meeting.guid,
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              size: 14,
                                              color: text2,
                                            ),
                                            spaceH5,
                                            Body1(
                                              text: 'Delete',
                                              color: text2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                        height: 14,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: text1,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          meetingsController.currentMeeting =
                                              meeting;
                                          Get.to(
                                            () => AdminShareMeeting(
                                              title:
                                                  "Share Meeting: ${meeting.guid}",
                                              meetingGuid: meeting.guid,
                                            ),
                                            routeName:
                                                "${AdminShareMeeting.routePath}/${meeting.guid}",
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.share_outlined,
                                              size: 14,
                                              color: text2,
                                            ),
                                            spaceH5,
                                            Body1(
                                              text: 'Share',
                                              color: text2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
                                            text: "Start",
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
