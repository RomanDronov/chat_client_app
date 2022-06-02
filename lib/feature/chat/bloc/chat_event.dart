part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.initialized({
    required Author recipient,
    @Default(null) String? chatId,
  }) = InitializedChatEvent;
  const factory ChatEvent.newMessage({required Message message}) = NewMessageChatEvent;
  const factory ChatEvent.sendMessage({required String text}) = SendMessageChatEvent;
}
