import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/common/widgets/form/form_button.dart';
import 'package:cosmic_assessments/controllers/admin/tests/test_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/landing.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/manage_test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';

class AdminTestSubmittedScreen extends StatefulWidget {
  static String routeName = "/a/test/submitted/:guid";
  static String routePath = "/a/test/submitted";
  final String title;

  const AdminTestSubmittedScreen({super.key, required this.title});

  @override
  State<AdminTestSubmittedScreen> createState() =>
      _AdminTestSubmittedScreenState();
}

class _AdminTestSubmittedScreenState extends State<AdminTestSubmittedScreen> {
  final testController = Get.find<AdminTestController>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Your Test Submitted Successfully',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FormButton(
              label: 'Go to Manage Test',
              onPressed: (() {
                Get.offNamedUntil(
                    AdminLandingScreen.routeName, (route) => false);
                Get.toNamed(
                  AdminTestsScreen.routeName,
                );
                Get.toNamed(
                  "${AdminManageTest.routePath}/${testController.currentTestGuid}",
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
