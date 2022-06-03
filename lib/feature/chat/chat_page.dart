import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../all_chats/models/domain/all_chats_details.dart';
import 'bloc/chat_bloc.dart';
import 'widgets/chat.dart';
import 'widgets/new_message.dart';

class ChatPage extends StatelessWidget {
  final Author recipient;
  final String? chatId;
  const ChatPage({Key? key, required this.recipient, this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        userRepository,
        socketProvider,
        configRepository,
      )..add(ChatEvent.initialized(recipient: recipient, chatId: chatId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(recipient.name),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(child: Chat()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
