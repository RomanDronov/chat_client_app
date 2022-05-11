import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import '../../models/message.dart';
import 'bloc/chat_bloc.dart';
import 'widgets/chat.dart';
import 'widgets/new_message.dart';

class ChatPage extends StatelessWidget {
  final ChatUser user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(userRepository)..add(ChatEvent.initialized(receiver: user)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (_, current) => current.map(
            loading: (_) => true,
            content: (_) => true,
            scrollToLatest: (_) => false,
          ),
          builder: (context, state) {
            return state.maybeMap(
              loading: (state) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              content: (state) {
                return ListView(
                  children: const [
                    Chat(),
                    NewMessage(),
                  ],
                );
              },
              orElse: Container.new,
            );
          },
        ),
      ),
    );
  }
}
