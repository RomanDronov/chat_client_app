part of 'all_chats_bloc.dart';

@freezed
class AllChatsEvent with _$AllChatsEvent {
  const factory AllChatsEvent.initialized() = InitializedAllChatsEvent;
  const factory AllChatsEvent.recipientPressed({
    required Author recipient,
    required String chatId,
  }) = RecipientPressedAllChatsEvent;
  const factory AllChatsEvent.profilePressed() = ProfilePressedAllChatEvent;
}
