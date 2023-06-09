import 'package:flutter/material.dart';

class AdminAssignmentsScreen extends StatefulWidget {
  static String routeName = "/a/assignments";
  final String title;
  const AdminAssignmentsScreen({super.key, required this.title});
  @override
  State<AdminAssignmentsScreen> createState() => _AdminAssignmentsScreenState();
}

class _AdminAssignmentsScreenState extends State<AdminAssignmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'List Assignments created by admin',
            ),
          ],
        ),
      ),
    );
  }
}
