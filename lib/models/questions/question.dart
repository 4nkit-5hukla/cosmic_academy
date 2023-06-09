import 'dart:convert';

import 'package:cosmic_assessments/models/questions/choice.dart';

Question questionFromMap(String str) => Question.fromMap(json.decode(str));

String questionToMap(Question data) => json.encode(data.toMap());

class Question {
  Question({
    required this.id,
    required this.guid,
    required this.question,
    required this.questionType,
    required this.feedback,
    required this.answerFeedback,
    required this.marks,
    required this.negMarks,
    this.time,
    this.fileHash,
    this.fileURLPath,
    this.parentGuid,
    this.parentType,
    this.parentQuestion,
    this.parentFileUrl,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    this.choices,
  });

  String id;
  String guid;
  String question;
  String questionType;
  String feedback;
  String answerFeedback;
  String marks;
  String negMarks;
  String? time;
  String? fileHash;
  String? fileURLPath;
  String? parentGuid;
  String? parentType;
  String? parentQuestion;
  String? parentFileUrl;
  String status;
  String createdBy;
  DateTime createdOn;
  List<Choice>? choices;

  Question copyWith({
    required String id,
    required String guid,
    required String question,
    required String questionType,
    required String feedback,
    required String answerFeedback,
    required String marks,
    required String negMarks,
    String? time,
    String? fileHash,
    String? fileURLPath,
    String? parentGuid,
    String? parentType,
    String? parentQuestion,
    String? parentFileUrl,
    required String status,
    required String createdBy,
    required DateTime createdOn,
    List<Choice>? choices,
  }) =>
      Question(
        id: id,
        guid: guid,
        question: question,
        questionType: questionType,
        feedback: feedback,
        answerFeedback: answerFeedback,
        marks: marks,
        negMarks: negMarks,
        time: time,
        fileHash: fileHash,
        fileURLPath: fileURLPath,
        parentGuid: parentGuid,
        parentType: parentType,
        parentQuestion: parentQuestion,
        parentFileUrl: parentFileUrl,
        status: status,
        createdBy: createdBy,
        createdOn: createdOn,
        choices: choices,
      );

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        id: json["ID"],
        guid: json["guid"],
        question: json["question"],
        questionType: json["question_type"],
        feedback: json["feedback"],
        answerFeedback: json["answer_feedback"],
        marks: json["marks"],
        negMarks: json["neg_marks"],
        time: json["time"],
        fileHash: json["file_hash"],
        fileURLPath: json["file_url_path"],
        parentGuid: json["parent_guid"],
        parentType: json["parent_type"],
        parentQuestion: json["parent_question"],
        parentFileUrl: json["parent_file_url"],
        status: json["status"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["created_on"]),
        choices: json["choices"] == null
            ? null
            : List<Choice>.from(json["choices"].map((x) => Choice.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "guid": guid,
        "question": question,
        "question_type": questionType,
        "feedback": feedback,
        "answer_feedback": answerFeedback,
        "marks": marks,
        "neg_marks": negMarks,
        "time": time,
        "file_hash": fileHash,
        "file_url_path": fileURLPath,
        "parent_guid": parentGuid,
        "parent_type": parentType,
        "parent_question": parentQuestion,
        "parent_file_url": parentFileUrl,
        "status": status,
        "created_by": createdBy,
        "created_on": createdOn.toIso8601String(),
        "choices": choices == null
            ? null
            : List<dynamic>.from(choices!.map((x) => x.toMap())),
      };
}
