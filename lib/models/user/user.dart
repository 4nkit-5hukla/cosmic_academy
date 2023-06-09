import 'package:get/get.dart';

class User {
  User({
    required this.guid,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.email,
    this.mobile,
    this.userMobile,
    this.role,
    this.active,
    this.userRegistered,
  });

  final String guid;
  String? firstName;
  String? middleName;
  String? lastName;
  String? username;
  String? email;
  String? mobile;
  String? userMobile;
  String? role;
  String? active;
  DateTime? userRegistered;

  String getFullName() => middleName != ''
      ? "${firstName!.capitalizeFirst} ${middleName!.capitalizeFirst} ${lastName!.capitalizeFirst}"
          .trim()
      : getDisplayName();

  String getDisplayName() =>
      "${firstName!.capitalizeFirst} ${lastName!.capitalizeFirst}".trim();

  factory User.fromMap(Map<String, dynamic> json) => User(
        guid: json["guid"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        mobile: json["mobile"],
        userMobile: json["user_mobile"],
        role: json["role"],
        active: json["active"],
        userRegistered: json["user_registered"] == null
            ? null
            : DateTime.parse(json["user_registered"]),
      );

  Map<String, dynamic> toMap() => {
        "guid": guid,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "mobile": "+$mobile",
        "user_mobile": "+$userMobile",
        "role": role,
        "active": active,
        "user_registered": userRegistered?.toIso8601String(),
      };
}
