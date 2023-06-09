import 'dart:convert';

List<LessonSection> lessonSectionFromJson(String str) =>
    List<LessonSection>.from(
        json.decode(str).map((x) => LessonSection.fromJson(x)));

String lessonSectionToJson(List<LessonSection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LessonSection {
  LessonSection({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.createdOn,
    this.updatedBy,
    this.updatedOn,
  });

  final String id;
  final String title;
  String createdBy;
  DateTime createdOn;
  String? updatedBy;
  DateTime? updatedOn;

  LessonSection copyWith({
    required String id,
    required String title,
    required String createdBy,
    required DateTime createdOn,
    String? updatedBy,
    DateTime? updatedOn,
  }) =>
      LessonSection(
        id: id,
        title: title,
        createdBy: createdBy,
        createdOn: createdOn,
        updatedBy: updatedBy,
        updatedOn: updatedOn,
      );

  factory LessonSection.fromJson(Map<String, dynamic> json) => LessonSection(
        id: json["id"],
        title: json["title"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedBy: json["updated_by"],
        updatedOn: DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_by": createdBy,
        "created_on": createdOn != null ? createdOn.toIso8601String() : null,
        "updated_by": updatedBy,
        "updated_on": updatedOn != null ? updatedOn!.toIso8601String() : null,
      };
}
