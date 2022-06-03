import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/gender.dart';

part 'all_chats_details.freezed.dart';

@freezed
class AllChatsDetails with _$AllChatsDetails {
  const factory AllChatsDetails({
    required LocationChat locationChat,
    required List<PrivateChat> privateChats,
  }) = _AllChatsDetails;
}

@freezed
class LocationChat with _$LocationChat {
  const factory LocationChat({
    required int currentlyOnline,
    required int distanceMeters,
  }) = _LocationChat;
}

@freezed
class Message with _$Message {
  const factory Message({
    required DateTime sentDateTime,
    required MessageContent content,
    required Author author,
  }) = _Message;
}

@freezed
class PrivateChat with _$PrivateChat {
  const factory PrivateChat({
    required String id,
    required Author recipient1,
    required Author recipient2,
    required Message lastMessage,
  }) = _PrivateChat;
}

@freezed
class MessageContent with _$MessageContent {
  const factory MessageContent({
    required String text,
  }) = _MessageContent;
}

@freezed
class Author with _$Author {
  const Author._();
  const factory Author({
    required String name,
    required String id,
    required Gender gender,
    required DateTime lastOnline,
  }) = _Author;

  bool get isOnline {
    final DateTime now = DateTime.now().toUtc();
    final DateTime lastOnline = this.lastOnline.toUtc();
    final Duration difference = now.difference(lastOnline);
    return difference.inSeconds < 60;
  }
}
