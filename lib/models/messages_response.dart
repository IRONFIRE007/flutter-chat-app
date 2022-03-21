// To parse this JSON data, do
//
//     final messagesResponse = messagesResponseFromJson(jsonString);

import 'dart:convert';

MessagesResponse messagesResponseFromJson(String str) =>
    MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) =>
    json.encode(data.toJson());

class MessagesResponse {
  MessagesResponse({
    required this.ok,
    required this.message,
  });

  bool ok;
  List<Message> message;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      MessagesResponse(
        ok: json["ok"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.of,
    required this.messageFor,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  String of;
  String messageFor;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        of: json["of"],
        messageFor: json["for"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "of": of,
        "for": messageFor,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
