import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import 'bloc/chat_bloc.dart';
import 'widgets/chat.dart';
import 'widgets/new_message.dart';

class ChatPage extends StatelessWidget {
  final ChatUser user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        userRepository,
        configRepository,
      )..add(ChatEvent.initialized(receiver: user)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.name),
          automaticallyImplyLeading: true,
        ),
        bottomNavigationBar: const NewMessage(),
        body: const Chat(),
      ),
    );
  }
}
