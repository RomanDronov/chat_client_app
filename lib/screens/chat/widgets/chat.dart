import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../models/message.dart';
import '../bloc/chat_bloc.dart';
import 'current_user_message.dart';
import 'other_user_message.dart';

class Chat extends HookWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (_, current) => current.maybeMap(
        content: (_) => true,
        orElse: () => false,
      ),
      builder: (BuildContext context, ChatState state) {
        return state.maybeMap(
          content: (ContentChatState state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                itemCount: state.messages.length,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = state.messages[index];
                  return message.senderID != state.currentUserId
                      ? OtherUserMessage(message: message.text)
                      : CurrentUserMessage(message: message.text);
                },
              ),
            );
          },
          orElse: Container.new,
        );
      },
    );
  }
}
