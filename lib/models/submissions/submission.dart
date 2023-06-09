import 'dart:convert';

List<Submission> submissionFromMap(String str) =>
    List<Submission>.from(json.decode(str).map((x) => Submission.fromMap(x)));

String submissionToMap(List<Submission> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Submission {
  final String guid;
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime startTime;
  DateTime? submitTime;
  DateTime? expiryTime;
  final String sessionId;
  final String testName;
  final String testGuid;

  Submission({
    required this.guid,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.startTime,
    this.submitTime,
    this.expiryTime,
    required this.sessionId,
    required this.testName,
    required this.testGuid,
  });

  factory Submission.fromMap(Map<String, dynamic> json) => Submission(
        guid: json["guid"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        startTime: DateTime.parse(json["start_time"]),
        submitTime: json["submit_time"] != null
            ? DateTime.parse(json["submit_time"])
            : null,
        expiryTime: json["expiry_time"] != null
            ? DateTime.parse(json["expiry_time"])
            : null,
        sessionId: json["session_id"],
        testName: json["test_name"],
        testGuid: json["test_guid"],
      );

  Map<String, dynamic> toMap() => {
        "guid": guid,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "start_time": startTime.toIso8601String(),
        "submit_time": submitTime?.toIso8601String(),
        "expiry_time": expiryTime?.toIso8601String(),
        "session_id": sessionId,
        "test_name": testName,
        "test_guid": testGuid,
      };
}
