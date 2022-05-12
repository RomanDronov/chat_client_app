import 'package:freezed_annotation/freezed_annotation.dart';

import 'gender.dart';

part 'chat_user.freezed.dart';

@freezed
class ChatUser with _$ChatUser {
  const factory ChatUser({
    required String name,
    required String id,
    required String email,
    required Gender gender,
  }) = _ChatUser;
}
