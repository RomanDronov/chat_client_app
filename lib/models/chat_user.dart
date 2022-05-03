import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user.freezed.dart';

@freezed
class ChatUser with _$ChatUser {
  const factory ChatUser({
    required String name,
    required String chatID,
    required String phoneNumber,
  }) = _ChatUser;
}
