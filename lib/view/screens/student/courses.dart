import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentCoursesScreen extends StatefulWidget {
  static String routeName = "/courses";
  final String title;
  const StudentCoursesScreen({super.key, required this.title});

  @override
  State<StudentCoursesScreen> createState() => _StudentCoursesScreenState();
}

class _StudentCoursesScreenState extends State<StudentCoursesScreen> {
  final String? data = Get.parameters['data'];
  final String? titleParam = Get.parameters['title'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(titleParam ?? widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data ?? 'List of courses Screen',
            ),
          ],
        ),
      ),
    );
  }
}
