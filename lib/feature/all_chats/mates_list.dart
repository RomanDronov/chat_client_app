import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import 'bloc/all_chats_bloc.dart';
import 'models/domain/all_chats_details.dart';

class MatesList extends StatelessWidget {
  const MatesList({
    Key? key,
    required this.users,
    required this.userId,
  }) : super(key: key);
  final List<PrivateChat> users;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...users.map((PrivateChat chat) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatTile(
                  chat: chat,
                  userId: userId,
                ),
                if (users.last != chat)
                  const Padding(
                    padding: EdgeInsets.only(left: 80, right: 16),
                    child: Divider(height: 1),
                  )
              ],
            ),
          );
        })
      ],
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.chat,
    required this.userId,
  }) : super(key: key);
  final PrivateChat chat;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final DateTime sentDateTime = chat.lastMessage.sentDateTime.toLocal();
    final DateTime now = DateTime.now();
    final DateFormat format = now.difference(sentDateTime).abs() > const Duration(days: 1)
        ? DateFormat.Md(Localizations.localeOf(context).languageCode)
        : DateFormat.Hm(Localizations.localeOf(context).languageCode);
    final Author recipient = chat.recipient1.id == userId ? chat.recipient2 : chat.recipient1;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(
          avatarProvider.getAssetNameByUsernameAndGender(
            recipient.name,
            recipient.gender,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 24,
      ),
      trailing: Text(format.format(sentDateTime)),
      title: Text(recipient.name),
      subtitle: Text(
        (recipient.id != chat.lastMessage.author.id ? '' : 'You: ') + chat.lastMessage.content.text,
      ),
      onTap: () {
        AllChatsBloc bloc = BlocProvider.of(context);
        AllChatsEvent event = AllChatsEvent.recipientPressed(recipient: recipient, chatId: chat.id);
        bloc.add(event);
      },
    );
  }
}
