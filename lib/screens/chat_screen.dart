import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  List<ChatMessage> _messages = [];
  final _focusNode = FocusNode();
  bool _write = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Column(
            children: <Widget>[
              CircleAvatar(
                child: const Text(
                  'Te',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue[100],
                maxRadius: 16,
              ),
              SizedBox(height: 3),
              const Text('Melissa Flores',
                  style: TextStyle(color: Colors.black87, fontSize: 12))
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
    final newMessage = new ChatMessage(
      uid: '123',
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    newMessage.animationController.forward();
    _messages.insert(0, newMessage);
    print(text);
    _textController.clear();
    _focusNode.requestFocus();
    setState(() {
      _write = false;
    });
  }

  @override
  void dispose() {
    // TODO: off Socket

    //Clear _messages
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
