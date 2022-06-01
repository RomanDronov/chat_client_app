import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  final String content;
  final String chatId;
  final String userId;
  final String recipientId;

  MessageDto(this.content, this.chatId, this.userId, this.recipientId);

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);
}
