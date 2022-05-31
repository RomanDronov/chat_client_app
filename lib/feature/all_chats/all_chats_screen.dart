import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/design/alert/alert.dart';
import '../../core/design/alert/alert_description.dart';
import '../../core/design/info/info.dart';
import '../../core/design/info/info_description.dart';
import '../../core/design/widgets/banner.dart';
import '../../core/design/widgets/section_header.dart';
import '../../main.dart';
import '../chat/chat_page.dart';
import '../profile/profile_screen.dart';
import 'bloc/all_chats_bloc.dart';
import 'mates_list.dart';
import 'models/domain/all_chats_details.dart';
import 'no_mates_yet.dart';

class AllChatsPage extends StatelessWidget {
  const AllChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: BlocProvider<AllChatsBloc>(
        create: (_) =>
            AllChatsBloc(allChatsService, userRepository)..add(const AllChatsEvent.initialized()),
        child: BlocConsumer<AllChatsBloc, AllChatsState>(
          buildWhen: (_, AllChatsState current) => current.map(
            loading: (_) => true,
            content: (_) => true,
            openChat: (_) => false,
            openProfile: (_) => false,
            showWarningAlert: (_) => false,
            failure: (_) => true,
          ),
          builder: (BuildContext context, AllChatsState state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.maybeMap(
                    orElse: () => localizations.allChats,
                    content: (ContentAllChatsState content) => content.currentUserName,
                  ),
                ),
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
                failure: (state) {
                  return DesignInfo(
                    description: InfoDescription(
                      title: 'Something went wrong',
                      description: 'Please try again or do it later',
                      type: InfoType.warning,
                      firstButton: InfoButton(
                        label: 'Try again',
                        onPressed: () {
                          context.read<AllChatsBloc>().add(const AllChatsEvent.initialized());
                        },
                      ),
                    ),
                  );
                },
                content: (ContentAllChatsState state) {
                  return ListView(
                    children: [
                      DesignBanner(
                        title: 'Meet neighbors',
                        subtitle:
                            '${state.details.locationChat.currentlyOnline} online within ${state.details.locationChat.distanceMeters} meters',
                      ),
                      const SectionHeader(title: 'Mates'),
                      if (state.details.privateChats.isNotEmpty)
                        MatesList(
                          users: state.details.privateChats,
                          userId: state.currentUserId,
                        )
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
              openChat: (OpenChatAllChatsState state) => _openChat(
                context,
                state.recipient,
                state.chatId,
              ),
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
      ),
    );
  }

  void _openChat(BuildContext context, Author recipient, String chatId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChatPage(recipient: recipient, chatId: chatId);
        },
      ),
    );
  }
}
