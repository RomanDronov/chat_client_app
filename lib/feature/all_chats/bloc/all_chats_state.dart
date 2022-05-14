part of 'all_chats_bloc.dart';

@freezed
class AllChatsState with _$AllChatsState {
  const factory AllChatsState.loading() = LoadingAllChatsState;
  const factory AllChatsState.content({required List<ChatUser> users}) = ContentAllChatsState;

  /// Sync State: Open chat with [user].
  const factory AllChatsState.openChat({required ChatUser user}) = OpenChatAllChatsState;
  const factory AllChatsState.openProfile() = OpenProfileAllChatsState;
  const factory AllChatsState.showWarningAlert({
    required String title,
    required String description,
    required AllChatsEvent retryEvent,
  }) = ShowWarningAlertAllChatsState;
}
