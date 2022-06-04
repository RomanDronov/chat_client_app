import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../all_chats/models/domain/all_chats_details.dart';
import '../bloc/chat_bloc.dart';
import 'current_user_message.dart';
import 'other_user_message.dart';

class Chat extends HookWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primary.withOpacity(0.01),
            ],
          ),
        ),
        child: BlocConsumer<ChatBloc, ChatState>(
          builder: (context, state) {
            return state.maybeMap(
              content: (ContentChatState state) {
                return ListView.builder(
                  itemCount: state.content.messages.length + 1,
                  controller: scrollController,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    final int length = state.content.messages.length;
                    if (index == 0) {
                      return const SizedBox(height: 16);
                    }
                    index -= 1;
                    final Message message = state.content.messages[length - index - 1];
                    return message.author.id != state.currentUserId
                        ? OtherUserMessage(
                            message: message.content.text,
                            author: message.author,
                            sentDateTimeUtc: message.sentDateTime,
                          )
                        : CurrentUserMessage(
                            message: message.content.text,
                            sentDateTimeUtc: message.sentDateTime,
                          );
                  },
                );
              },
              orElse: Container.new,
            );
          },
          listener: (context, state) {
            state.mapOrNull(
              scrollToIndex: (state) {
                if (scrollController.positions.isEmpty) {
                  return;
                }
                scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
