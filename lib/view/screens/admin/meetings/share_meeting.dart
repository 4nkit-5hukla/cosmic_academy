import 'package:cosmic_assessments/controllers/meetings/meeting_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/users_controller.dart';
import 'package:cosmic_assessments/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/meetings/meetings_controller.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';

class AdminShareMeeting extends StatefulWidget {
  static String routeName = "/a/share-meeting/:guid";
  static String routePath = "/a/share-meeting";
  final String title;
  final String meetingGuid;
  const AdminShareMeeting(
      {super.key, required this.title, required this.meetingGuid});

  @override
  State<AdminShareMeeting> createState() => _AdminShareMeetingState();
}

class _AdminShareMeetingState extends State<AdminShareMeeting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bNC = Get.find<BottomNavigationController>();
  final meetingsController = Get.find<MeetingsController>();
  final meetingController = Get.put(MeetingController());
  final usersController = Get.put(UsersController());
  List<String> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    usersController.numResults('9999999');
    usersController.fetchUsers().then((value) {
      meetingController.currentMeetingGuid(widget.meetingGuid);
      meetingController.fetchMeetingUsers().then((value) {
        setState(() {
          selectedUsers = meetingController.currentMeetingUsers;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Get.back();
          },
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
          ),
        ],
      ),
      drawer: AdminSidebar(),
      body: Obx(
        () {
          if (usersController.isLoading.value ||
              meetingController.isLoading.value) {
            return const Loader();
          } else {
            if (usersController.usersList.isNotEmpty) {
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
                      children: const [
                        Heading3(text: 'Select a User'),
                      ],
                    ),
                  ),
                  spaceV15,
                  Expanded(
                    child: ListView.builder(
                      controller: usersController.scrollController,
                      itemCount: usersController.usersList.length,
                      itemBuilder: (context, index) {
                        User user = usersController.usersList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Card(
                            elevation: 0,
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: selectedUsers.contains(user.guid),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      Body1(
                                        text: '${index + 1}',
                                        color: black,
                                      ),
                                      spaceH5,
                                      Body1(
                                        text: user.getDisplayName(),
                                        color: black,
                                      ),
                                    ],
                                  ),
                                  Body2(
                                    text: user.guid,
                                    color: black,
                                  ),
                                ],
                              ),
                              onChanged: (bool? checked) {
                                if (checked == true) {
                                  selectedUsers.add(user.guid);
                                } else {
                                  selectedUsers.remove(user.guid);
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
                  if (usersController.isNextLoading.value == true)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 30,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Map<String, String> usersData =
                                selectedUsers.asMap().map((index, userGuid) {
                              return MapEntry(
                                "users[$index]",
                                userGuid,
                              );
                            });
                            meetingsController
                                .shareMeeting(widget.meetingGuid, usersData)
                                .then((value) {
                              Get.back();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: const Body1(
                              text: "Share",
                              color: white,
                            ),
                          ),
                        ),
                      ],
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
                      "No Students found.",
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
