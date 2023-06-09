import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/controllers/admin/users/filter_option.dart';
import 'package:cosmic_assessments/models/user/user.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class UsersController extends GetxController with BaseController {
  RxInt firstPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt totalResults = 0.obs;
  RxString numResults = '15'.obs;
  RxBool isLoading = false.obs;
  RxBool isNextLoading = false.obs;
  RxString search = ''.obs;
  RxString orderBy = 'newest_first'.obs;
  RxString role = ''.obs;
  RxString archived = '0'.obs;
  RxString status = ''.obs;
  List<User> usersList = List<User>.empty(growable: true).obs;
  late User? currentUser = null.obs as User?;
  ScrollController scrollController = ScrollController();
  final List<FilterOption> perPageOptions = [
    FilterOption(
      value: '15',
      label: '15 at a Time',
    ),
    FilterOption(
      value: '30',
      label: '30 at a Time',
    ),
    FilterOption(
      value: '50',
      label: '50 at a Time',
    ),
    FilterOption(
      value: '100',
      label: '100 at a Time',
    ),
  ];
  final List<FilterOption> orderByOptions = [
    FilterOption(
      value: 'newest_first',
      label: 'Newest First',
    ),
    FilterOption(
      value: 'newest_last',
      label: 'Newest Last',
    ),
    FilterOption(
      value: 'last_name_asc',
      label: 'Last Name Asc',
    ),
    FilterOption(
      value: 'last_name_desc',
      label: 'Last Name Desc',
    ),
    FilterOption(
      value: 'first_name_asc',
      label: 'First Name Asc',
    ),
    FilterOption(
      value: 'first_name_desc',
      label: 'First Name Desc',
    ),
  ];
  final List<FilterOption> roleOptions = [
    FilterOption(
      value: '',
      label: 'All Roles',
    ),
    FilterOption(
      value: 'admin',
      label: 'Admin',
    ),
    // FilterOption(
    //   value: 'branch_admin',
    //   label: 'Branch Admin',
    // ),
    FilterOption(
      value: 'student',
      label: 'Student',
    ),
    // FilterOption(
    //   value: 'staff',
    //   label: 'Staff',
    // ),
    // FilterOption(
    //   value: 'parent',
    //   label: 'Parent',
    // ),
    // FilterOption(
    //   value: 'teacher',
    //   label: 'Teacher',
    // ),
  ];
  final List<FilterOption> statusOptions = [
    FilterOption(
      value: '',
      label: 'All',
    ),
    FilterOption(
      value: '1',
      label: 'Active',
    ),
    FilterOption(
      value: '0',
      label: 'In Active',
    ),
  ];

  final List<FilterOption> archivedOptions = [
    FilterOption(
      value: '0',
      label: 'Hide',
    ),
    FilterOption(
      value: '1',
      label: 'Show',
    ),
  ];
  final Map messages = {
    "USERS_ACTIVATED_SUCCESSFULLY": "Users Activated Successfully",
    "USERS_DEACTIVATED_SUCCESSFULLY": "Users Deactivated Successfully",
    "USERS_ARCHIVED_SUCCESSFULLY": "Users Archived Successfully",
    "USERS_DELETED_SUCCESSFULLY": "Users Deleted Successfully",
    "ROLES_CHANGED_SUCCESSFULLY": "Roles Changed Successfully",
  };

  paginateUsers() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage.value < lastPage.value) {
          currentPage(currentPage.value + 1);
          fetchMoreUsers(currentPage);
        }
      }
    });
  }

  void clearFilters() {
    numResults('15');
    orderBy('newest_first');
    role('');
    status('');
    archived('0');
  }

  void clearSearch() {
    search('');
  }

  Future fetchUsers() async {
    isLoading(true);
    currentPage(1);
    var res = await BaseClient().formPost("/users/list", {
      'results_per_page': numResults.value,
      'order_by': orderBy.value,
      'role': role.value,
      'status': status.value,
      'archived': archived.value,
      'search': search.value,
    }).catchError(handleError);
    isLoading(false);
    if (res == null) return;
    Map data = json.decode(res);
    List<User> users = List<User>.from(
      data['payload']['data'].map(
        (x) => User.fromMap(
          x,
        ),
      ),
    );
    firstPage(data['payload']['meta']['first_page']);
    lastPage(data['payload']['meta']['last_page']);
    currentPage(data['payload']['meta']['current_page']);
    totalResults(data['payload']['meta']['total_results']);
    usersList.assignAll(users);
  }

  void fetchMoreUsers(RxInt page) async {
    isNextLoading(true);
    print("fetching page $page");
    var res = await BaseClient().formPost("/users/list", {
      'results_per_page': numResults.value,
      'order_by': orderBy.value,
      'role': role.value,
      'status': status.value,
      'archived': archived.value,
      'search': search.value,
      'page': page.value.toString()
    }).catchError(handleError);
    if (res == null) return;
    Map data = json.decode(res);
    List<User> users = List<User>.from(
      data['payload']['data'].map(
        (x) => User.fromMap(
          x,
        ),
      ),
    );
    usersList.addAll(users);
    isNextLoading(false);
    // update();
  }

  Future changeRole(Map<String, String> selectedUsers) async {
    isLoading(true);
    var res = await BaseClient()
        .formPost("/users/change_role", selectedUsers)
        .catchError(handleError);
    Map data = json.decode(res);
    print(data);
    if (data['success'] == true &&
        data['message'] == "ROLES_CHANGED_SUCCESSFULLY") {
      role('');
      await fetchUsers();
      return messages[data['message']] ?? "Success";
    } else {
      role('');
      isLoading(false);
      return messages[data['message']] ?? "Something went wrong";
    }
  }

  Future activateUsers(Map<String, String> selectedUsers) async {
    isLoading(true);
    var res = await BaseClient()
        .formPost("/users/activate", selectedUsers)
        .catchError(handleError);
    Map data = json.decode(res);
    print(data);
    if (data['success'] == true &&
        data['message'] == "USERS_ACTIVATED_SUCCESSFULLY") {
      await fetchUsers();
      return messages[data['message']] ?? "Success";
    } else {
      role('');
      isLoading(false);
      return messages[data['message']] ?? "Something went wrong";
    }
  }

  Future deActivateUsers(Map<String, String> selectedUsers) async {
    isLoading(true);
    var res = await BaseClient()
        .formPost("/users/deactivate", selectedUsers)
        .catchError(handleError);
    Map data = json.decode(res);
    print(data);
    if (data['success'] == true &&
        data['message'] == "USERS_DEACTIVATED_SUCCESSFULLY") {
      await fetchUsers();
      return messages[data['message']] ?? "Success";
    } else {
      role('');
      isLoading(false);
      return messages[data['message']] ?? "Something went wrong";
    }
  }

  Future archiveUsers(Map<String, String> selectedUsers) async {
    isLoading(true);
    var res = await BaseClient()
        .formPost("/users/archive", selectedUsers)
        .catchError(handleError);
    Map data = json.decode(res);
    print(data);
    if (data['success'] == true &&
        data['message'] == "USERS_ARCHIVED_SUCCESSFULLY") {
      await fetchUsers();
      return messages[data['message']] ?? "Success";
    } else {
      role('');
      isLoading(false);
      return messages[data['message']] ?? "Something went wrong";
    }
  }

  Future deleteUsers(Map<String, String> selectedUsers) async {
    isLoading(true);
    var res = await BaseClient()
        .formPost("/users/delete", selectedUsers)
        .catchError(handleError);
    Map data = json.decode(res);
    print(data);
    if (data['success'] == true &&
        data['message'] == "USERS_DELETED_SUCCESSFULLY") {
      await fetchUsers();
      return messages[data['message']] ?? "Success";
    } else {
      role('');
      isLoading(false);
      return messages[data['message']] ?? "Something went wrong";
    }
  }
}
