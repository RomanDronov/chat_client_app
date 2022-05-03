//* all the logic for socket and all the data will be stored.

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/chat_user.dart';
import '../models/message.dart';
import 'authentication_model.dart';
import 'firestore_model.dart';

class AppModel extends Model with AuthenticationModel, FirestoreModel {
  List<ChatUser> users = <ChatUser>[];
  List<ChatUser> friendList = <ChatUser>[];
  List<Message> messages = <Message>[];
  late IO.Socket socketIO;
  final serverUrl =
      'localhost:8080'; // TODO use your server link here (download and clone my other repo)
  bool isLoading = true;

  final listController = ScrollController();

  void init() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    currentUser = currentUser?.copyWith(chatID: user.uid);
    users = await getAllUsers();
    isLoading = false;
    notifyListeners();

    friendList = users.where((user) => user.chatID != currentUser?.chatID).toList();

    prepareSocket();
  }

  void sendMessage(String text, String receiverChatID) {
    final ChatUser? currentUser = this.currentUser;
    if (currentUser == null) {
      return;
    }
    messages.add(Message(text, currentUser.chatID, receiverChatID));
    socketIO.emit(
      'send_message',
      json.encode(
        {
          'receiverChatID': receiverChatID,
          'senderChatID': currentUser.chatID,
          'content': text,
        },
      ),
    );
    notifyListeners();

    // Animate the lis to the lastest message
    final animateToPostion = listController.position.maxScrollExtent + 100;

    listController.animateTo(
      animateToPostion,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages.where((msg) => msg.senderID == chatID || msg.receiverID == chatID).toList();
  }

  void prepareSocket() {
    final ChatUser? currentUser = this.currentUser;
    if (currentUser == null) {
      return;
    }
    socketIO = IO.io('$serverUrl/chatID=${currentUser.chatID}');

    socketIO.on('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      messages.add(Message(data['content'], data['senderChatID'], data['receiverChatID']));
      notifyListeners(); // update UI
      // Animate the lis to the lastest message
      final animateToPostion = listController.position.maxScrollExtent + 100;

      listController.animateTo(
        animateToPostion,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 500),
      );
    });

    socketIO.connect();
  }
}
