part of 'all_chats_bloc.dart';

@freezed
class AllChatsState with _$AllChatsState {
  const factory AllChatsState.loading() = LoadingAllChatsState;
  const factory AllChatsState.failure() = FailureAllChatsState;
  const factory AllChatsState.content({
    required AllChatsDetails details,
    required String currentUserId,
    required String currentUserName,
  }) = ContentAllChatsState;

  /// Sync State: Open chat with [user].
  const factory AllChatsState.openChat({
    required Author recipient,
    required String chatId,
  }) = OpenChatAllChatsState;
  const factory AllChatsState.openProfile() = OpenProfileAllChatsState;
  const factory AllChatsState.showWarningAlert({
    required String title,
    required String description,
    required AllChatsEvent retryEvent,
  }) = ShowWarningAlertAllChatsState;
}
