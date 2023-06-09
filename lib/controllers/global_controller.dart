import 'dart:io';
import 'dart:convert';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class GlobalController extends GetxController with BaseController {
  String lang = 'EN-IN'; // EN-IN, HI-IN
  String ver = '0.0.1';
  RxBool loadingTheme = true.obs;
  RxString token = ''.obs;
  RxString userId = ''.obs;
  RxString country = 'IN'.obs;
  RxString deviceName = ''.obs;
  RxString dialingCode = ''.obs;
  RxString primaryColorStr = ''.obs;
  RxBool enableUserRegistration = enableSignUp.obs;
  RxString signInField = signInType.obs;
  MaterialColor mainColor = primary;
  Color contrastColor = black;

  @override
  onInit() async {
    super.onInit();
    getCountry();
    getDeviceInfo();
  }

  Future<String> getTheme() async {
    loadingTheme(true);
    Uri themeUri = BaseClient().getURI("/settings/general/get_theme");
    final response = await BaseClient.client.get(themeUri);
    dynamic data = json.decode(response.body);
    if (isDebug) {
      print(data);
    }
    loadingTheme(false);
    if (data['success']) {
      return data["payload"]["theme_color"];
    } else {
      return "";
    }
  }

  getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceName(androidInfo.id.trim());
      if (isDebug) {
        print(androidInfo.id);
      }
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName(iosInfo.identifierForVendor?.trim());
      if (isDebug) {
        print(iosInfo.identifierForVendor?.trim());
      }
    }
  }

  getCountry() async {
    final response = await BaseClient.client
        .get(Uri.parse('https://iplist.cc/api'))
        .catchError(
          handleError,
        );
    ;
    // if (isDebug) {
    //   print(response.body);
    // }
    dynamic data = json.decode(response.body);
    if (data == null) return;
    country(data['countrycode']);
  }
}
