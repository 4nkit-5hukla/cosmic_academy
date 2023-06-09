import 'package:flutter/material.dart';

class AdminQnAScreen extends StatefulWidget {
  static String routeName = "/a/qna";
  final String title;
  const AdminQnAScreen({super.key, required this.title});
  @override
  State<AdminQnAScreen> createState() => _AdminQnAScreenState();
}

class _AdminQnAScreenState extends State<AdminQnAScreen> {
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
              'Lists of QnA created by admin',
            ),
          ],
        ),
      ),
    );
  }
}
