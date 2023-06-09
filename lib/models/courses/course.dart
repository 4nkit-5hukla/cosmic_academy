import 'dart:convert';

List<Course> courseFromJson(String str) => List<Course>.from(
      json.decode(str).map(
            (x) => Course.fromMap(
              x,
            ),
          ),
    );

String courseToJson(List<Course> data) => json.encode(
      List<dynamic>.from(
        data.map(
          (x) => x.toMap(),
        ),
      ),
    );

class Course {
  Course({
    required this.guid,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    required this.updatedBy,
    required this.updatedOn,
  });

  final String guid;
  String title;
  String description;
  String status;
  String createdBy;
  DateTime createdOn;
  String updatedBy;
  DateTime updatedOn;

  factory Course.fromMap(Map<String, dynamic> map) => Course(
        guid: map["guid"],
        title: map["title"],
        description: map["description"],
        status: map["status"],
        createdBy: map["created_by"],
        createdOn: DateTime.parse(map["created_on"]),
        updatedBy: map["updated_by"],
        updatedOn: DateTime.parse(map["updated_on"]),
      );

  Map<String, String> toMap() => {
        "guid": guid,
        "title": title,
        "description": description,
        "status": status,
        "created_by": createdBy,
        "created_on": createdOn.toIso8601String(),
        "updated_by": updatedBy,
        "updated_on": updatedOn.toIso8601String(),
      };
}
