import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

late ChatService chatService;
late SocketService socketService;
late AuthService authService;

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();

  List<ChatMessage> _messages = [];
  final _focusNode = FocusNode();
  bool _write = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('message-private', _listenMessage);

    _loadHHistory(chatService.userPara.uid);
  }

  void _loadHHistory(String userId) async {
    List<Message> chat = await chatService.getChat(userId);

    // print(chat);

    final history = chat.map((e) => ChatMessage(
        text: e.message,
        uid: e.of,
        animationController: AnimationController(
            vsync: this, duration: Duration(microseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    print(payload['message']);
    ChatMessage message = ChatMessage(
        text: payload['message'],
        uid: payload['of'],
        animationController: AnimationController(
            vsync: this, duration: Duration(microseconds: 300)));

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userPara = chatService.userPara;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Column(
            children: <Widget>[
              CircleAvatar(
                child: Text(
                  userPara.name.substring(0, 2),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
                maxRadius: 16,
              ),
              const SizedBox(height: 3),
              Text(userPara.name,
                  style: const TextStyle(color: Colors.black87, fontSize: 12))
            ],
          ),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            Divider(height: 1),
            //Box Text
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        )));
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
                child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String text) {
                //Conditions
                setState(() {
                  if (text.trim().length > 0) {
                    _write = true;
                  } else {
                    _write = false;
                  }
                });
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send Message'),
              focusNode: _focusNode,
            )),
            //Buttom Send
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _write
                          ? () => _handleSubmit(_textController.text)
                          : null)
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: const Icon(
                              Icons.send,
                            ),
                            onPressed: _write
                                ? () => _handleSubmit(_textController.text)
                                : null),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    newMessage.animationController.forward();
    _messages.insert(0, newMessage);
    // print(text);
    _textController.clear();
    _focusNode.requestFocus();
    setState(() {
      _write = false;
    });

    socketService.emit('message-private', {
      'of': authService.user.uid,
      'for': chatService.userPara.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    // TODO: off Socket

    //Clear _messages
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('message-private');
    super.dispose();
  }
}
