import 'package:flutter/foundation.dart';
import 'package:cosmic_assessments/models/user/user_role.dart';

const bool isDebug = kDebugMode;

const String appTitle = "Cosmic Assessment";

const bool enableSignUp = false;
const String signInType = "email"; // "email" || "username"

UserRole admin = const UserRole(label: 'Admin', value: 'admin');
UserRole bAdmin = const UserRole(
  label: 'Branch Admin',
  value: 'branch_admin',
);

UserRole staff = const UserRole(label: 'Staff', value: 'staff');
UserRole teacher = const UserRole(label: 'Teacher', value: 'teacher');
UserRole parent = const UserRole(label: 'Parent', value: 'parent');
UserRole student = const UserRole(label: 'Student', value: 'student');

List<String> userRoles = [
  admin.value,
  // bAdmin.value,
  // staff.value,
  teacher.value,
  // parent.value,
  student.value
];

UserStatus disable = const UserStatus(label: 'Disable', value: '0');
UserStatus enable = const UserStatus(label: 'Enable', value: '1');
UserStatus archived = const UserStatus(label: 'Archived', value: '2');

List<UserStatus> userStatus = <UserStatus>[enable, disable, archived];

UserStatus getStatus(String status) =>
    userStatus.firstWhere((element) => element.value.toString() == status);

String getInitials({required String name}) {
  List<String> nameParts = name.split(' ');

  if (nameParts.length >= 2) {
    String firstNameInitial = nameParts[0][0];
    String lastNameInitial = nameParts[1][0];
    return firstNameInitial + lastNameInitial;
  } else if (nameParts.length == 1) {
    return nameParts[0][0];
  } else {
    return '';
  }
}

String baseUrl = 'https://developer1.website/dev/caapis/public';
String ipRegKey = 'yxjmzmcf20n2rqm0';

const int timeOutDuration = 20;
