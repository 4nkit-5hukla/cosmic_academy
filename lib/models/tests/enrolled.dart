// To parse this JSON data, do
//
//     final enrolled = enrolledFromJson(jsonString);

import 'dart:convert';

List<Enrolled> enrolledFromJson(String str) => List<Enrolled>.from(
      json.decode(str).map(
            (x) => Enrolled.fromJson(
              x,
            ),
          ),
    );

String enrolledToJson(List<Enrolled> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toJson(),
        ),
      ),
    );

class Enrolled {
  final String testId;
  final DateTime startDate;
  final DateTime endDate;
  final String guid;
  final String firstName;
  final String lastName;

  Enrolled({
    required this.testId,
    required this.startDate,
    required this.endDate,
    required this.guid,
    required this.firstName,
    required this.lastName,
  });

  Enrolled copyWith({
    String? testId,
    DateTime? startDate,
    DateTime? endDate,
    String? guid,
    String? firstName,
    String? lastName,
  }) =>
      Enrolled(
        testId: testId ?? this.testId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        guid: guid ?? this.guid,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory Enrolled.fromJson(Map<String, dynamic> json) => Enrolled(
        testId: json["test_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        guid: json["guid"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "test_id": testId,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "guid": guid,
        "first_name": firstName,
        "last_name": lastName,
      };
}
