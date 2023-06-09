// To parse this JSON data, do
//
//     final test = testFromJson(jsonString);

import 'dart:convert';

List<Test> testFromJson(String str) =>
    List<Test>.from(json.decode(str).map((x) => Test.fromJson(x)));

String testToJson(List<Test> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Test {
  final String id;
  final String guid;
  String title;
  String type;
  String details;
  String status;
  String createdBy;
  DateTime createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  Settings settings;
  Stats? stats;

  Test({
    required this.id,
    required this.guid,
    required this.title,
    required this.type,
    required this.details,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    this.updatedBy,
    this.updatedOn,
    required this.settings,
    this.stats,
  });

  Test copyWith({
    String? id,
    String? guid,
    String? title,
    String? type,
    String? details,
    String? status,
    String? createdBy,
    DateTime? createdOn,
    String? updatedBy,
    DateTime? updatedOn,
    Settings? settings,
    Stats? stats,
  }) =>
      Test(
        id: id ?? this.id,
        guid: guid ?? this.guid,
        title: title ?? this.title,
        type: type ?? this.type,
        details: details ?? this.details,
        status: status ?? this.status,
        createdBy: createdBy ?? this.createdBy,
        createdOn: createdOn ?? this.createdOn,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedOn: updatedOn ?? this.updatedOn,
        settings: settings ?? this.settings,
        stats: stats ?? this.stats,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ID': id,
      'guid': guid,
      'title': title,
      'type': type,
      'details': details,
      'status': status,
      'created_by': createdBy,
      'created_on': createdOn,
      'updated_by': updatedBy,
      'updated_on': updatedOn,
    };
  }

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: json["ID"],
        guid: json["guid"],
        title: json["title"],
        type: json["type"],
        details: json["details"],
        status: json["status"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(
          json["created_on"],
        ),
        updatedBy: json["updated_by"],
        updatedOn: DateTime.parse(
          json["updated_on"],
        ),
        settings: Settings.fromJson(json["settings"]),
        stats: Stats.fromJson(json["stats"]),
      );

  factory Test.fromMap(Map<String, dynamic> map) => Test(
        id: map["ID"],
        guid: map["guid"],
        title: map["title"],
        type: map["type"],
        details: map["details"],
        status: map["status"],
        createdBy: map["created_by"],
        createdOn: DateTime.parse(
          map["created_on"],
        ),
        updatedBy: map["updated_by"],
        updatedOn: DateTime.parse(
          map["updated_on"],
        ),
        settings: Settings.fromJson(map["settings"]),
        stats: map["stats"] != null ? Stats.fromJson(map["stats"]) : null,
      );

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'Test(ID: $id, guid: $guid, title: $title, type: $type, details: $details, status: $status, created_on: $createdOn, created_by: $createdBy, updated_on: $updatedBy, updated_by: $updatedOn,)';
}

class Settings {
  Settings({
    required this.marksPerQuestion,
    required this.negMarksPerQuestion,
    required this.numAttempts,
    required this.onDate,
    this.passMarks,
    required this.passMarksUnit,
    required this.showResult,
    required this.showTimer,
    required this.testDuration,
    required this.timePerQuestion,
  });

  String marksPerQuestion;
  String negMarksPerQuestion;
  String numAttempts;
  String onDate;
  String? passMarks;
  String passMarksUnit;
  String showResult;
  String showTimer;
  String testDuration;
  String timePerQuestion;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        marksPerQuestion: json["marks_per_question"],
        negMarksPerQuestion: json["neg_marks_per_question"],
        numAttempts: json["num_attempts"],
        onDate: json["on_date"],
        passMarks: json["pass_marks"],
        passMarksUnit: json["pass_marks_unit"],
        showResult: json["show_result"],
        showTimer: json["show_timer"],
        testDuration: json["test_duration"],
        timePerQuestion: json["time_per_question"],
      );

  Map<String, dynamic> toJson() => {
        "marks_per_question": marksPerQuestion,
        "neg_marks_per_question": negMarksPerQuestion,
        "num_attempts": numAttempts,
        "on_date": onDate,
        "pass_marks": passMarks,
        "pass_marks_unit": passMarksUnit,
        "show_result": showResult,
        "show_timer": showTimer,
        "test_duration": testDuration,
        "time_per_question": timePerQuestion,
      };
}

class Stats {
  Stats({
    required this.submissions,
    required this.questions,
    required this.attempts,
    required this.marks,
    required this.negMarks,
  });

  int submissions;
  int questions;
  int attempts;
  int marks;
  int negMarks;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        submissions: json["submissions"],
        questions: json["questions"],
        attempts: json["attempts"],
        marks: json["marks"].runtimeType == String
            ? int.parse(json["marks"])
            : json["marks"],
        negMarks: json["neg_marks"].runtimeType == String
            ? int.parse(json["neg_marks"])
            : json["neg_marks"],
      );

  Map<String, dynamic> toJson() => {
        "submissions": submissions,
        "questions": questions,
        "attempts": attempts,
        "marks": marks,
        "neg_marks": negMarks,
      };
}
