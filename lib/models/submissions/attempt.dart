import 'dart:convert';

List<Attempt> attemptFromMap(String str) =>
    List<Attempt>.from(json.decode(str).map((x) => Attempt.fromMap(x)));

String attemptToMap(List<Attempt> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Attempt {
  String userName;
  DateTime startTime;
  DateTime? submitTime;
  DateTime? expiryTime;
  String sessionId;

  Attempt({
    required this.userName,
    required this.startTime,
    this.submitTime,
    this.expiryTime,
    required this.sessionId,
  });

  Attempt copyWith({
    required String userName,
    required DateTime startTime,
    DateTime? submitTime,
    DateTime? expiryTime,
    required String sessionId,
  }) =>
      Attempt(
        userName: userName,
        startTime: startTime,
        submitTime: submitTime,
        expiryTime: expiryTime,
        sessionId: sessionId,
      );

  factory Attempt.fromMap(Map<String, dynamic> json) => Attempt(
        userName: json["user_name"],
        startTime: DateTime.parse(json["start_time"]),
        submitTime: json["submit_time"] == null
            ? null
            : DateTime.parse(json["submit_time"]),
        expiryTime: json["expiry_time"] == null
            ? null
            : DateTime.parse(json["expiry_time"]),
        sessionId: json["session_id"],
      );

  Map<String, dynamic> toMap() => {
        "user_name": userName,
        "start_time": startTime.toIso8601String(),
        "submit_time": submitTime?.toIso8601String(),
        "expiry_time": expiryTime?.toIso8601String(),
        "session_id": sessionId,
      };
}
