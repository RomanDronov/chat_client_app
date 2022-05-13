part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.loading() = LoadingChatState;
  const factory ChatState.content({
    required ChatContent content,
    required String currentUserId,
  }) = ContentChatState;
  const factory ChatState.scrollToIndex({required int index}) = ScrollToLatestChatState;
}

class ChatContent {
  final List<Message> messages;

  ChatContent(this.messages);
}
