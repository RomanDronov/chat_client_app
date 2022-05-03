import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/chat_user.dart';
import '../models/message.dart';
import '../scoped_models/app_model.dart';

class ChatPage extends StatefulWidget {
  final ChatUser friend;
  const ChatPage({Key? key, required this.friend}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();

  Widget buildSingleMessage(Message message) {
    Widget bubble = message.senderID != widget.friend.chatID
        ? ChatBubble(
            clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 20),
            backGroundColor: Colors.blue,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        : ChatBubble(
            clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
            backGroundColor: const Color(0xffE7E7ED),
            margin: const EdgeInsets.only(top: 20),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );

    return bubble;
  }

  Widget buildChatList() {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        List<Message> messages = model.getMessagesForChatID(widget.friend.chatID);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: messages.length,
            controller: model.listController,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(messages[index]);
            },
          ),
        );
      },
    );
  }

  Widget buildChatArea() {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: textEditingController,
              ),
            ),
            const SizedBox(width: 10.0),
            FloatingActionButton(
              onPressed: () {
                model.sendMessage(
                  textEditingController.text,
                  widget.friend.chatID,
                );
                textEditingController.text = '';
              },
              elevation: 0,
              child: const Icon(Icons.send),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
      ),
      body: ListView(
        children: <Widget>[
          buildChatList(),
          buildChatArea(),
        ],
      ),
    );
  }
}
