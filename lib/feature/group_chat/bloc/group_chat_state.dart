part of 'group_chat_bloc.dart';

@freezed
class GroupChatState with _$GroupChatState {
  const factory GroupChatState.loading() = LoadingChatState;
  const factory GroupChatState.content({
    required ChatContent content,
    required String currentUserId,
  }) = ContentChatState;
  const factory GroupChatState.scrollToIndex({required int index}) = ScrollToLatestChatState;
}

class ChatContent {
  final List<Message> messages;

  ChatContent(this.messages);
}
