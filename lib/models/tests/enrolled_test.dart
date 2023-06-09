// To parse this JSON data, do
//
//     final enrolledTest = enrolledTestFromJson(jsonString);

import 'dart:convert';

List<EnrolledTest> enrolledTestFromJson(String str) => List<EnrolledTest>.from(
    json.decode(str).map((x) => EnrolledTest.fromJson(x)));

String enrolledTestToJson(List<EnrolledTest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EnrolledTest {
  final String guid;
  final String type;
  final String title;
  final String details;
  final DateTime startDate;
  final DateTime endDate;
  final String releaseResult;
  final String releaseResultDate;

  EnrolledTest({
    required this.guid,
    required this.type,
    required this.title,
    required this.details,
    required this.startDate,
    required this.endDate,
    required this.releaseResult,
    required this.releaseResultDate,
  });

  factory EnrolledTest.fromJson(Map<String, dynamic> json) => EnrolledTest(
        guid: json["guid"],
        type: json["type"],
        title: json["title"],
        details: json["details"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        releaseResult: json["release_result"],
        releaseResultDate: json["release_result_date"],
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "type": type,
        "title": title,
        "details": details,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "release_result": releaseResult,
        "release_result_date": releaseResultDate,
      };
}
