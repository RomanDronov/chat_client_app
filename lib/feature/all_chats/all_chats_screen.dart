import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/alert/alert.dart';
import '../../core/design/alert/alert_description.dart';
import '../../core/design/widgets/banner.dart';
import '../../core/design/widgets/section_header.dart';
import '../../main.dart';
import '../../models/chat_user.dart';
import '../chat/chat_page.dart';
import '../profile/profile_screen.dart';
import 'bloc/all_chats_bloc.dart';
import 'mates_list.dart';
import 'no_mates_yet.dart';

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
          openProfile: (_) => false,
          showWarningAlert: (_) => false,
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
            ),
            body: state.maybeMap(
              loading: (LoadingAllChatsState state) {
                return const Center(child: CircularProgressIndicator());
              },
              content: (ContentAllChatsState state) {
                return ListView(
                  children: [
                    const DesignBanner(),
                    const SectionHeader(title: 'Mates'),
                    if (state.users.isNotEmpty)
                      MatesList(users: state.users)
                    else
                      const NoMatesYet(),
                  ],
                );
              },
              orElse: Container.new,
            ),
          );
        },
        listener: (BuildContext context, AllChatsState state) {
          state.mapOrNull(
            openChat: (OpenChatAllChatsState state) => _openChat(context, state.user),
            openProfile: (_) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            ),
            showWarningAlert: (state) {
              final AlertDescription description = AlertDescription(
                type: AlertType.warning,
                title: state.title,
                description: state.description,
                isDismissible: false,
                firstButton: AlertButton(
                  label: 'Try again',
                  onPressed: () {
                    context.read<AllChatsBloc>().add(state.retryEvent);
                  },
                ),
              );
              showDesignAlert(context, description);
            },
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
