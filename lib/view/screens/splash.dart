import 'dart:async';
import 'package:cosmic_assessments/common/utils/img.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/auth_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/view/screens/admin/landing.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';
import 'package:cosmic_assessments/view/screens/student/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  final globalController = Get.find<GlobalController>();
  final authController = Get.put(AuthController());

  loadApp() async {
    await authController.getCommon();
    await authController.getFields();
    String? token = await storage.read(key: 'token');
    String? userId = await storage.read(key: 'userId');
    if (token == null && userId == null) {
      // await Future.delayed(
      //   const Duration(
      //     seconds: 3,
      //   ),
      // );
      Get.offNamed(
        SignInScreen.routeName,
      );
      return;
    }
    globalController.userId(userId);
    globalController.token(token);
    authController.getAuthorizedUser().then((isAuthorized) {
      if (isAuthorized) {
        Get.offNamed(
          authController.userRole.value == "admin"
              ? AdminLandingScreen.routeName
              : StudentLandingScreen.routeName,
        );
      } else {
        Get.offNamed(
          SignInScreen.routeName,
        );
      }
    });
  }

  @override
  void initState() {
    loadApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    Img.get(
                      'loading.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                appTitle,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 5,
                width: 80,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
