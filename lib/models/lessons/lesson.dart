import 'dart:convert';

List<Lesson> lessonsFromJson(String str) =>
    List<Lesson>.from(json.decode(str).map((x) => Lesson.fromJson(x)));

String lessonsToJson(List<Lesson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Lesson {
  Lesson({
    required this.guid,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    this.updatedBy,
    this.updatedOn,
  });

  final String guid;
  String title;
  String description;
  String status;
  String createdBy;
  DateTime createdOn;
  String? updatedBy;
  DateTime? updatedOn;

  Lesson copyWith(Map<String, String> map, {
    String? guid,
    String? title,
    String? description,
    String? status,
    String? createdBy,
    DateTime? createdOn,
    String? updatedBy,
    DateTime? updatedOn,
  }) =>
      Lesson(
        guid: guid ?? this.guid,
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        createdBy: createdBy ?? this.createdBy,
        createdOn: createdOn ?? this.createdOn,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedOn: updatedOn ?? this.updatedOn,
      );

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        guid: json["guid"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedBy: json["updated_by"],
        updatedOn: DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toMap() => {
        "guid": guid,
        "title": title,
        "description": description,
        "status": status,
        "created_by": createdBy,
        "created_on": createdOn.toIso8601String(),
        "updated_by": updatedBy,
        "updated_on": updatedOn?.toIso8601String(),
      };
}
