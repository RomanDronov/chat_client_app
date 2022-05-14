import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import '../../models/gender.dart';
import 'bloc/all_chats_bloc.dart';

class MatesList extends StatelessWidget {
  const MatesList({
    Key? key,
    required this.users,
  }) : super(key: key);
  final List<ChatUser> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...users.map((ChatUser user) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      avatarProvider.getAssetNameByUsernameAndGender(
                        user.name,
                        user.gender,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 24,
                  ),
                  title: Text(user.name),
                  subtitle: const Text('Last message'),
                  onTap: () {
                    AllChatsBloc bloc = BlocProvider.of(context);
                    AllChatsEvent event = AllChatsEvent.userPressed(user: user);
                    bloc.add(event);
                  },
                ),
                if (users.last != user)
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
