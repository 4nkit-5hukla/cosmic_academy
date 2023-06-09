import 'dart:convert';

List<LessonContent> lessonContentFromJson(String str) =>
    List<LessonContent>.from(
        json.decode(str).map((x) => LessonContent.fromJson(x)));

String lessonContentToJson(List<LessonContent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LessonContent {
  LessonContent({
    required this.contentId,
    required this.content,
    required this.position,
    required this.type,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    this.fileHash,
    this.updatedBy,
    this.updatedOn,
  });

  final String contentId;
  String content;
  String position;
  String type;
  String status;
  String? fileHash;
  final String createdBy;
  final DateTime createdOn;
  String? updatedBy;
  DateTime? updatedOn;

  LessonContent copyWith({
    required String contentId,
    required String content,
    required String position,
    required String type,
    required String status,
    String? fileHash,
    required String createdBy,
    required DateTime createdOn,
    String? updatedBy,
    DateTime? updatedOn,
  }) =>
      LessonContent(
        contentId: contentId,
        content: content,
        position: position,
        type: type,
        status: status,
        fileHash: fileHash,
        createdBy: createdBy,
        createdOn: createdOn,
        updatedBy: updatedBy,
        updatedOn: updatedOn,
      );

  factory LessonContent.fromJson(Map<String, dynamic> json) => LessonContent(
        contentId: json["content_id"],
        content: json["content"],
        position: json["position"],
        type: json["type"],
        status: json["status"],
        fileHash: json["file_hash"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedBy: json["updated_by"],
        updatedOn: DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "content": content,
        "position": position,
        "type": type,
        "status": status,
        "file_hash": fileHash,
        "created_by": createdBy,
        "created_on": createdOn.toIso8601String(),
        "updated_by": updatedBy,
        "updated_on": updatedOn != null ? updatedOn!.toIso8601String() : null,
      };
}
