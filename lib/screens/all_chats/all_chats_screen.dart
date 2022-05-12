import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import '../chat/chat_page.dart';
import '../profile/profile_screen.dart';
import '../startup/start_up_screen.dart';
import 'bloc/all_chats_bloc.dart';

class AllChatsPage extends StatelessWidget {
  const AllChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllChatsBloc>(
      create: (_) => AllChatsBloc(userRepository)..add(const AllChatsEvent.initialized()),
      child: BlocConsumer<AllChatsBloc, AllChatsState>(
        buildWhen: (_, AllChatsState current) => current.map(
          loading: (_) => true,
          content: (_) => true,
          openChat: (_) => false,
          logout: (_) => false,
          openProfile: (_) => false,
        ),
        builder: (BuildContext context, AllChatsState state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Chats'),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  context.read<AllChatsBloc>().add(const AllChatsEvent.profilePressed());
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<AllChatsBloc>().add(const AllChatsEvent.logoutPressed());
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: state.maybeMap(
              loading: (LoadingAllChatsState state) {
                return const Center(child: CircularProgressIndicator());
              },
              content: (ContentAllChatsState state) {
                return ListView.separated(
                  itemCount: state.users.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 80, right: 16),
                      child: Divider(height: 1),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    ChatUser user = state.users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          radius: 24,
                        ),
                        title: Text(user.name),
                        subtitle: Text('Last message'),
                        onTap: () {
                          AllChatsBloc bloc = BlocProvider.of(context);
                          AllChatsEvent event = AllChatsEvent.userPressed(user: user);
                          bloc.add(event);
                        },
                      ),
                    );
                  },
                );
              },
              orElse: Container.new,
            ),
          );
        },
        listener: (BuildContext context, AllChatsState state) {
          state.mapOrNull(
            openChat: (OpenChatAllChatsState state) => _openChat(context, state.user),
            logout: (_) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const StartUpScreen(),
              ),
            ),
            openProfile: (_) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context, ChatUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChatPage(user: user);
        },
      ),
    );
  }
}
