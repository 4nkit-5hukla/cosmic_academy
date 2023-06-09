import 'package:flutter/material.dart';

class AdminViewMeeting extends StatefulWidget {
  static String routeName = "/a/meeting/:guid";
  static String routePath = "/a/meeting";
  final String title;
  const AdminViewMeeting({super.key, required this.title});

  @override
  State<AdminViewMeeting> createState() => _AdminViewMeetingState();
}

class _AdminViewMeetingState extends State<AdminViewMeeting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: const Center(
        child: Text(
          'Hello',
        ),
      ),
    );
  }
}
