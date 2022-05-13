part of 'all_chats_bloc.dart';

@freezed
class AllChatsEvent with _$AllChatsEvent {
  const factory AllChatsEvent.initialized() = InitializedAllChatsEvent;
  const factory AllChatsEvent.userPressed({required ChatUser user}) = UserPressedAllChatsEvent;
  const factory AllChatsEvent.logoutPressed() = LogoutPressedAllChatsEvent;
  const factory AllChatsEvent.profilePressed() = ProfilePressedAllChatEvent;
}
