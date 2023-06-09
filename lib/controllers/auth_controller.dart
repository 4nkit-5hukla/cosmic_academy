import 'dart:convert';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class AuthController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final GlobalKey<FormBuilderState> signUpFormKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> forgotFormKey =
      GlobalKey<FormBuilderState>();
  PageController signUpPageController = PageController(
    initialPage: 0,
  );
  RxBool isLoading = false.obs;
  RxBool allowUserRegistration = false.obs;
  RxBool autoGenerateUserName = false.obs;
  RxBool autoApproveUser = true.obs;
  RxString defaultUserRole = student.value.obs;
  RxBool useMobile = false.obs;
  RxBool useEmail = true.obs;
  RxString otp = ''.obs;
  RxString newUserId = ''.obs;
  RxString userId = ''.obs;
  RxString userGuId = ''.obs;
  RxString userName = ''.obs;
  RxString userDisplayName = ''.obs;
  RxString userFullName = ''.obs;
  RxString userRole = ''.obs;
  RxString? userFirstName = ''.obs;
  RxString? userMiddleName = ''.obs;
  RxString? useLastName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userPhone = ''.obs;
  RxString forgotOTP = ''.obs;
  RxString forgotToken = ''.obs;
  final Map messages = {
    "USER_CREATED_PENDING_FOR_APPROVAL":
        "Register successful, Pending for approval",
    "USER_CREATED_SUCCESSFULLY": "Your can proceed with the login.",
    "USER_NOT_FOUND": "User Not Found",
    "INVALID_CREDENTIALS": "Username or Password is incorrect",
    "TOKEN_NOT_FOUND": "Token Not Found",
  };

  String getMessage(String key) {
    return messages[key];
  }

  String getAddressingName() {
    return userFirstName!.value.capitalizeFirst!.trim();
  }

  String getUserFullName() {
    return userMiddleName!.value != ''
        ? "${userFirstName!.value.capitalizeFirst!} ${userMiddleName!.value.capitalizeFirst!} ${useLastName!.value.capitalizeFirst!}"
        : getUserDisplayName();
  }

  String getUserDisplayName() {
    return "${userFirstName!.value.capitalizeFirst!} ${useLastName!.value.capitalizeFirst!}"
        .trim();
  }

  Future getCommon() async {
    String endpoint = "/settings/registration/common";
    var res = await BaseClient().get(endpoint).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success']) {
      autoApproveUser(data['payload']['auto_approve_user'] == 'true');
      allowUserRegistration(
          data['payload']['allow_user_registration'] == 'true');
      autoGenerateUserName(data['payload']['auto_generate_username'] == 'true');
      defaultUserRole(data['payload']['default_user_role']);
    }
  }

  Future getFields() async {
    String endpoint = "/settings/registration/valid_fields";
    var res = await BaseClient().get(endpoint).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    if (data['success']) {
      useMobile(data['payload']['fields']['mobile'] == 'true');
      useEmail(data['payload']['fields']['email'] == 'true');
    }
  }

  Future<bool> getAuthorizedUser() async {
    isLoading(true);
    String endpoint = "/users/token_details";
    var res = await BaseClient()
        .get(
          endpoint,
        )
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    if (data['success'] && data['messages'] == "USER_FOUND") {
      userId(data["payload"]["user_id"]);
      userGuId(data["payload"]["guid"]);
      userRole(data["payload"]["role"]);
      if (data["payload"]["first_name"] != null) {
        userFirstName!(data["payload"]["first_name"]);
      }
      if (data["payload"]["middle_name"] != null) {
        userMiddleName!(data["payload"]["middle_name"]);
      }
      if (data["payload"]["last_name"] != null) {
        useLastName!(data["payload"]["last_name"]);
      }
      userEmail(data["payload"]["email"]);
      userPhone(data["payload"]["mobile"]);
      return true;
    } else {
      Get.snackbar(
        "Error",
        getMessage(
          data["messages"] ?? "Something went wrong",
        ),
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        duration: const Duration(
          seconds: 10,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
  }

  Future<bool> logOutUser() async {
    isLoading(true);
    String endpoint = "/auth/logout";
    var res = await BaseClient()
        .get(
          endpoint,
        )
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    }
    Map data = json.decode(res);
    if (data['success']) {
      globalController.token('');
      return true;
    } else {
      Get.snackbar(
        "Error",
        data['messages'],
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        duration: const Duration(
          seconds: 10,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    }
  }

  Future<bool> logInUser(dynamic logInData) async {
    isLoading(true);
    String endpoint = "/auth/login";
    var res = await BaseClient()
        .formPost(endpoint, logInData, null, null, false)
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    if (data['success']) {
      globalController.token(data["payload"]["token"]);
      return getAuthorizedUser();
    } else {
      Get.snackbar(
        "Error",
        messages[data['messages']],
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        duration: const Duration(
          seconds: 10,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
  }

  Future<bool> sendOTP() async {
    isLoading(true);
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    isLoading(false);

    Get.snackbar(
      "Verify you mobile number",
      "Enter Your One Time Password.",
      icon: const Icon(
        Icons.info_outline,
        color: white,
      ),
      duration: const Duration(
        seconds: 5,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: globalController.mainColor,
      colorText: white,
      borderRadius: 0,
      margin: const EdgeInsets.all(
        0,
      ),
    );
    return true;
  }

  Future<bool> checkOTP() async {
    isLoading(true);
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    isLoading(false);
    if (otp.value == '1234') {
      Get.snackbar(
        "Verified Successfully",
        "Mobile number verification done.",
        icon: const Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        duration: const Duration(
          seconds: 5,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: globalController.mainColor,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    } else {
      Get.snackbar(
        "Error",
        "Your One Time Password is Incorrect.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        duration: const Duration(
          seconds: 10,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
  }

  Future<bool> continueSignUp() async {
    isLoading(true);
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    isLoading(false);

    Get.snackbar(
      "All Set",
      "Ready for the sign up.",
      icon: const Icon(
        Icons.info_outline,
        color: white,
      ),
      duration: const Duration(
        seconds: 5,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: globalController.mainColor,
      colorText: white,
      borderRadius: 0,
      margin: const EdgeInsets.all(
        0,
      ),
    );
    return true;
  }

  Future<bool> createAccount(dynamic userData) async {
    isLoading(true);
    String endpoint = "/auth/register";
    print(userData);
    var res = await BaseClient()
        .formPost(endpoint, userData, null, null, false)
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    print(data);
    if (data['success']) {
      newUserId(data["payload"]["guid"]);

      Get.snackbar(
        "Success",
        messages[data["message"]] ?? "Registered",
        icon: const Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        duration: const Duration(
          seconds: 5,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: globalController.mainColor,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    } else {
      if (data['message'] != null && data['message'] != '') {
        Get.snackbar(
          "Error",
          "Validation Failed",
          messageText: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data['message']
                .entries
                .map<Widget>(
                  (entry) => Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: white,
                    ),
                  ),
                )
                .toList(),
          ),
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
          borderRadius: 0,
          margin: const EdgeInsets.all(
            0,
          ),
          duration: const Duration(
            seconds: 10,
          ),
        );
        return false;
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          duration: const Duration(
            seconds: 10,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
        );
        return false;
      }
    }
  }

  Future<bool> updateAccountInfo(Map<String, String> userData) async {
    isLoading(true);
    String endpoint = "/users/add/$newUserId";
    var res = await BaseClient()
        .formPost(
          endpoint,
          userData,
        )
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    print(data);
    if (data['success'] && data['message'] == 'USER_UPDATED_SUCCESSFULLY') {
      Get.snackbar(
        "Update Successful",
        "Your can proceed with the login.",
        icon: const Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        duration: const Duration(
          seconds: 5,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    } else {
      Get.snackbar(
        "Error",
        data['messages'],
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        duration: const Duration(
          seconds: 10,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
  }

  Future<bool> verifyMobile(Map<String, String> userData) async {
    isLoading(true);
    String endpoint = "/auth/password/verify_username";
    var res = await BaseClient()
        .formPost(endpoint, userData, null, null, false)
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    if (data['success'] && data['message'] == "USER_FOUND") {
      forgotOTP(data["payload"]["otp"]);

      Get.snackbar(
        "Verify you mobile number",
        "Enter Your One Time Password.",
        icon: const Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        duration: const Duration(
          seconds: 5,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    } else {
      if (data['message'] != null && data['message'] != '') {
        Get.snackbar(
          "Error",
          "Validation Failed",
          messageText: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data['message']
                .entries
                .map<Widget>(
                  (entry) => Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: white,
                    ),
                  ),
                )
                .toList(),
          ),
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
          borderRadius: 0,
          margin: const EdgeInsets.all(
            0,
          ),
          duration: const Duration(
            seconds: 10,
          ),
        );
        return false;
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          duration: const Duration(
            seconds: 10,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
        );
        return false;
      }
    }
  }

  Future<bool> verifyOTP(Map<String, String> userData) async {
    isLoading(true);
    String endpoint = "/auth/password/verify_otp";
    var res = await BaseClient()
        .formPost(endpoint, userData, null, null, false)
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    print(data);
    if (data['success'] && data['message'] == "OTP_VERIFIED") {
      forgotToken(data["payload"]["token"]);

      Get.snackbar(
        "Mobile Verified",
        "Now you can change your password.",
        icon: const Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        duration: const Duration(
          seconds: 5,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    } else {
      if (data['message'] != null &&
          data['message'] == 'OTP_NOT_VERIFED_OR_EXPIRED') {
        Get.snackbar(
          "Error",
          "Unable to Verify OTP or is Expired.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          duration: const Duration(
            seconds: 5,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
          borderRadius: 0,
          margin: const EdgeInsets.all(
            0,
          ),
        );
        return false;
      } else if (data['message'] != null && !data['message'].entries.isBlank) {
        Get.snackbar(
          "Error",
          "Validation Failed",
          messageText: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data['message']
                .entries
                .map<Widget>(
                  (entry) => Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: white,
                    ),
                  ),
                )
                .toList(),
          ),
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
          borderRadius: 0,
          margin: const EdgeInsets.all(
            0,
          ),
          duration: const Duration(
            seconds: 10,
          ),
        );
        return false;
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          duration: const Duration(
            seconds: 10,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
        );
        return false;
      }
    }
  }

  Future<bool> changePassword(Map<String, String> userData) async {
    isLoading(true);
    print(userData);
    String endpoint = "/auth/password/change";
    var res = await BaseClient()
        .formPost(endpoint, userData, null, null, false)
        .catchError(
          handleError,
        );
    isLoading(false);
    if (res == null) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade500,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return false;
    }
    Map data = json.decode(res);
    print(data);
    if (data['success'] && data['message'] == "PASSWORD_CHANGED_SUCCESSFULLY") {
      Get.snackbar(
        "Password Changed",
        "Now you can use your new password.",
        icon: const Icon(
          Icons.check_circle_outline,
          color: white,
        ),
        duration: const Duration(
          seconds: 5,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
        colorText: white,
        borderRadius: 0,
        margin: const EdgeInsets.all(
          0,
        ),
      );
      return true;
    } else {
      if (data['message'] != null && data['message'] != '') {
        Get.snackbar(
          "Error",
          "Validation Failed",
          messageText: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data['message']
                .entries
                .map<Widget>(
                  (entry) => Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: white,
                    ),
                  ),
                )
                .toList(),
          ),
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
          borderRadius: 0,
          margin: const EdgeInsets.all(
            0,
          ),
          duration: const Duration(
            seconds: 10,
          ),
        );
        return false;
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong.",
          icon: const Icon(
            Icons.warning,
            color: white,
          ),
          duration: const Duration(
            seconds: 10,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: white,
        );
        return false;
      }
    }
  }
}
