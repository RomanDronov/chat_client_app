import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/gender.dart';
import '../domain/all_chats_details.dart' as domain;
import '../domain/get_all_chats_details_result.dart' as domain;

part 'all_chats_response.g.dart';

@JsonSerializable()
class GetAllChatsResponse {
  final LocationChatDto locationChat;
  final List<PrivateChatDto> privateChats;

  GetAllChatsResponse(this.locationChat, this.privateChats);

  factory GetAllChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllChatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllChatsResponseToJson(this);
}

@JsonSerializable()
class LocationChatDto {
  final int currentlyOnline;
  final int distanceMeters;

  LocationChatDto(this.currentlyOnline, this.distanceMeters);

  factory LocationChatDto.fromJson(Map<String, dynamic> json) => _$LocationChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationChatDtoToJson(this);
}

@JsonSerializable()
class MessageDto {
  final AuthorDto author;
  final MessageContentDto content;
  final DateTime sentDateTimeUtc;

  MessageDto(this.author, this.content, this.sentDateTimeUtc);

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}

@JsonSerializable()
class PrivateChatDto {
  final String id;
  final AuthorDto recipient1;
  final AuthorDto recipient2;
  final MessageDto lastMessage;

  PrivateChatDto(this.id, this.recipient1, this.recipient2, this.lastMessage);

  factory PrivateChatDto.fromJson(Map<String, dynamic> json) => _$PrivateChatDtoFromJson(json);
}

@JsonSerializable()
class MessageContentDto {
  final String text;

  MessageContentDto(this.text);

  factory MessageContentDto.fromJson(Map<String, dynamic> json) =>
      _$MessageContentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageContentDtoToJson(this);
}

@JsonSerializable()
class AuthorDto {
  final String name;
  final String id;
  final String gender;
  final DateTime lastOnline;

  AuthorDto(this.name, this.id, this.gender, this.lastOnline);

  factory AuthorDto.fromJson(Map<String, dynamic> json) => _$AuthorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorDtoToJson(this);
}

extension GetAllChatsResponseExtension on GetAllChatsResponse {
  domain.GetAllChatsDetailsResult toDomain() {
    return domain.GetAllChatsDetailsResult.success(
      details: domain.AllChatsDetails(
        locationChat: domain.LocationChat(
          currentlyOnline: locationChat.currentlyOnline,
          distanceMeters: locationChat.distanceMeters,
        ),
        privateChats: privateChats.map((PrivateChatDto chat) {
          return domain.PrivateChat(
            id: chat.id,
            recipient1: chat.recipient1.toDomain(),
            recipient2: chat.recipient2.toDomain(),
            lastMessage: chat.lastMessage.toDomain(),
          );
        }).toList(),
      ),
    );
  }
}

extension MessageExtension on MessageDto {
  domain.Message toDomain() {
    return domain.Message(
      content: domain.MessageContent(text: content.text),
      author: author.toDomain(),
      sentDateTime: sentDateTimeUtc.toUtc(),
    );
  }
}

extension AuthorExtension on AuthorDto {
  domain.Author toDomain() {
    return domain.Author(
      id: id,
      name: name,
      gender: getGenderByCodeOrElse(gender, Gender.cat),
      lastOnline: lastOnline,
    );
  }
}
