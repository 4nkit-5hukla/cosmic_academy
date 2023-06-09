// To parse this JSON data, do
//
//     final unEnrolled = unEnrolledFromJson(jsonString);

import 'dart:convert';

List<UnEnrolled> unEnrolledFromJson(String str) =>
    List<UnEnrolled>.from(json.decode(str).map((x) => UnEnrolled.fromJson(x)));

String unEnrolledToJson(List<UnEnrolled> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnEnrolled {
  final String guid;
  final String firstName;
  final String lastName;

  UnEnrolled({
    required this.guid,
    required this.firstName,
    required this.lastName,
  });

  UnEnrolled copyWith({
    String? guid,
    String? firstName,
    String? lastName,
  }) =>
      UnEnrolled(
        guid: guid ?? this.guid,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory UnEnrolled.fromJson(Map<String, dynamic> json) => UnEnrolled(
        guid: json["guid"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "first_name": firstName,
        "last_name": lastName,
      };
}
