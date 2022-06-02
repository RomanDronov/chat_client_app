import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../main.dart';
import '../all_chats/models/domain/all_chats_details.dart';
import 'bloc/group_chat_bloc.dart';
import 'widgets/chat.dart';
import 'widgets/new_message.dart';

class GroupChatPage extends StatelessWidget {
  const GroupChatPage({Key? key, required this.position}) : super(key: key);
  final Position position;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupChatBloc(
        userRepository,
        configRepository,
      )..add(GroupChatEvent.initialized(position: position)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your neighborhood'),
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
