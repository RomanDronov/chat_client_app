part of 'group_chat_bloc.dart';

@freezed
class GroupChatEvent with _$GroupChatEvent {
  const factory GroupChatEvent.initialized({
    required Position position,
  }) = InitializedGroupChatEvent;
  const factory GroupChatEvent.newMessage({required Message message}) = NewMessageGroupChatEvent;
  const factory GroupChatEvent.sendMessage({required String text}) = SendMessageGroupChatEvent;
}
