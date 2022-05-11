part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.loading() = LoadingChatState;
  const factory ChatState.content({
    required List<Message> messages,
    required String currentUserId,
  }) = ContentChatState;
  const factory ChatState.scrollToLatest() = ScrollToLatestChatState;
}
