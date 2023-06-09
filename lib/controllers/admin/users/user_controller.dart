import 'dart:convert';

import 'package:cosmic_assessments/controllers/admin/users/users_controller.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/user/user.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class UserController extends GetxController with BaseController {
  final globalController = Get.find<GlobalController>();
  final usersController = Get.find<UsersController>();
  RxBool isLoading = false.obs;
  RxString currentUserGuid = "".obs;
  late User currentUser;
  final Map messages = {
    'USER_NOT_FOUND': 'User Not Found.',
    'USER_ACTIVATED_SUCCESSFULLY': 'User Activated Successfully.',
    'USER_ARCHIVED_SUCCESSFULLY': 'User Archived Successfully.',
    'USER_DEACTIVATED_SUCCESSFULLY': 'User Deactivated Successfully.',
    'USER_DELETED_SUCCESSFULLY': 'User Deleted Successfully.',
    'USER_ADDED_SUCCESSFULLY': 'User Added Successfully.',
    'USER_UPDATED_SUCCESSFULLY': 'User Updated Successfully.'
  };

  void fetchUser() async {
    if (currentUserGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get("/users/view/$currentUserGuid")
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      if (data['success']) {
        currentUser = User.fromMap(data['payload']);
      } else {
        Get.snackbar(
          "Error",
          data['message'],
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading(false);
      update();
    }
  }

  Future addUpdateUser(dynamic userData) async {
    String endpoint = currentUserGuid.value == ""
        ? "/users/add"
        : "/users/add/$currentUserGuid";
    isLoading(true);
    var res =
        await BaseClient().formPost(endpoint, userData).catchError(handleError);
    if (res == null) return;
    isLoading(false);
    Map data = json.decode(res);
    if (data['success']) {
      if (data['message'] == 'USER_ADDED_SUCCESSFULLY' ||
          data['message'] == 'USER_UPDATED_SUCCESSFULLY') {
        await usersController.fetchUsers().then((value) {
          usersController.paginateUsers();
        });
        Get.back();
        if (currentUserGuid.value != "") {
          Get.back();
        }
        Get.snackbar(
          "Success",
          messages[data['message']],
          icon: const Icon(
            Icons.check,
            color: white,
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: globalController.mainColor,
          colorText: white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: white,
      );
    }
    update();
  }

  Future deleteUser(bool deleteForever) async {
    isLoading(true);
    var res = await BaseClient().formPost(
      "/users/delete/$currentUserGuid",
      {
        "delete": deleteForever ? '1' : '0',
      },
    ).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true) {
      await usersController.fetchUsers().then((value) {
        usersController.paginateUsers();
      });
      Get.back();
      Get.back();
      Get.snackbar(
        "Success",
        messages[data['message']],
        icon: const Icon(
          Icons.check,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: globalController.mainColor,
        colorText: white,
      );
    } else {
      Get.snackbar(
        "Error",
        messages[data['message']] ?? "Something went wrong.",
        icon: const Icon(
          Icons.warning,
          color: white,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: white,
      );
    }
    update();
  }

  Future<String> activateUser() async {
    isLoading(true);
    var res = await BaseClient()
        .formPost(
          "/users/activate/$currentUserGuid",
        )
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true &&
        data['message'] == "USER_ACTIVATED_SUCCESSFULLY") {
      return messages[data['message']] ?? "Success";
    } else {
      return messages[data['message']] ?? "Something went wrong";
    }
  }

  Future<String> archiveUser() async {
    isLoading(true);
    var res = await BaseClient()
        .formPost(
          "/users/archive/$currentUserGuid",
        )
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true &&
        data['message'] == "USER_ARCHIVED_SUCCESSFULLY") {
      return messages[data['message']] ?? "Success";
    } else {
      return messages[data['message']] ?? "Something went wrong";
    }
  }

  Future<String> deactivateUser() async {
    isLoading(true);
    var res = await BaseClient()
        .formPost(
          "/users/deactivate/$currentUserGuid",
        )
        .catchError(handleError);
    Map data = json.decode(res);
    isLoading(false);
    if (data['success'] == true &&
        data['message'] == "USER_DEACTIVATED_SUCCESSFULLY") {
      return messages[data['message']] ?? "Success";
    } else {
      return messages[data['message']] ?? "Something went wrong";
    }
  }
}
