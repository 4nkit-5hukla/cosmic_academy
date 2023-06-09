import 'dart:convert';

List<Meeting> meetingFromJson(String str) =>
    List<Meeting>.from(json.decode(str).map((x) => Meeting.fromJson(x)));

String meetingToJson(List<Meeting> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meeting {
  Meeting({
    required this.guid,
    required this.details,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
  });

  String guid;
  String details;
  DateTime createdOn;
  String createdBy;
  DateTime updatedOn;
  String updatedBy;

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        guid: json["guid"],
        details: json["details"],
        createdOn: DateTime.parse(json["created_on"]),
        createdBy: json["created_by"],
        updatedOn: DateTime.parse(json["updated_on"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "details": details,
        "created_on": createdOn.toIso8601String(),
        "created_by": createdBy,
        "updated_on": updatedOn.toIso8601String(),
        "updated_by": updatedBy,
      };
}
