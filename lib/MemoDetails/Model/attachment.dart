// To parse this JSON data, do
//
//     final attachment = attachmentFromJson(jsonString);

import 'dart:convert';

List<Attachment> attachmentFromJson(String str) => List<Attachment>.from(json.decode(str).map((x) => Attachment.fromJson(x)));

String attachmentToJson(List<Attachment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attachment {
  String fileUrl;
  int documentId;

  Attachment({
    required this.fileUrl,
    required this.documentId,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    fileUrl: json["fileUrl"],
    documentId: json["documentId"],
  );

  Map<String, dynamic> toJson() => {
    "fileUrl": fileUrl,
    "documentId": documentId,
  };
}
