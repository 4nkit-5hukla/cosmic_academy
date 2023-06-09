import 'package:flutter/material.dart';

class DeleteCategoryTestPopUp extends StatefulWidget {
  final String title;

  const DeleteCategoryTestPopUp({super.key, required this.title});

  @override
  State<DeleteCategoryTestPopUp> createState() =>
      _DeleteCategoryTestPopUpState();
}

class _DeleteCategoryTestPopUpState extends State<DeleteCategoryTestPopUp> {
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
          children: [
            const Text('To Delete existing test category Screen'),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
