import 'dart:convert';

import 'package:cosmic_assessments/models/reports/report_answer.dart';

List<Report> reportFromMap(String str) =>
    List<Report>.from(json.decode(str).map((x) => Report.fromMap(x)));

String reportToMap(List<Report> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Report {
  Report({
    required this.numCorrect,
    required this.numWrong,
    required this.numNotAttempted,
    required this.marksObtained,
    required this.result,
    required this.answers,
  });

  int numCorrect;
  int numWrong;
  int numNotAttempted;
  int marksObtained;
  String result;
  List<ReportAnswer> answers;

  Report copyWith({
    required int numCorrect,
    required int numWrong,
    required int numNotAttempted,
    required int marksObtained,
    required String result,
    required List<ReportAnswer> answers,
  }) =>
      Report(
        numCorrect: numCorrect,
        numWrong: numWrong,
        numNotAttempted: numNotAttempted,
        marksObtained: marksObtained,
        result: result,
        answers: answers,
      );

  factory Report.fromMap(Map<String, dynamic> json) => Report(
        numCorrect: json["num_correct"],
        numWrong: json["num_wrong"],
        numNotAttempted: json["num_not_attempted"],
        marksObtained: json["marks_obtained"],
        result: json["result"],
        answers: List<ReportAnswer>.from(
            json["answers"].map((x) => ReportAnswer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "num_correct": numCorrect,
        "num_wrong": numWrong,
        "num_not_attempted": numNotAttempted,
        "marks_obtained": marksObtained,
        "result": result,
        "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
      };
}
