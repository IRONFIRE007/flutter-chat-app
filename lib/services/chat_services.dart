import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late User userPara;

  Future<List<Message>> getChat(String userId) async {
    final url = Uri.parse('${Environment.apiUrl}/messages/$userId');

    final token = await AuthService.getToken();
    final res = await http.get(url,
        headers: {'Content-Type': 'application/json', 'x-token': '$token'});

    final messagesResponse = messagesResponseFromJson(res.body);

    return messagesResponse.message;
  }
}
