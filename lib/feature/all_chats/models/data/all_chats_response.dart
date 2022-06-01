import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/gender.dart';
import '../domain/all_chats_details.dart' as domain;
import '../domain/get_all_chats_details_result.dart' as domain;

part 'all_chats_response.g.dart';

@JsonSerializable()
class GetAllChatsResponse {
  final LocationChat locationChat;
  final List<PrivateChat> privateChats;

  GetAllChatsResponse(this.locationChat, this.privateChats);

  factory GetAllChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllChatsResponseFromJson(json);
}

@JsonSerializable()
class LocationChat {
  final int currentlyOnline;
  final int distanceMeters;
  final Message lastMessage;

  LocationChat(this.currentlyOnline, this.distanceMeters, this.lastMessage);

  factory LocationChat.fromJson(Map<String, dynamic> json) => _$LocationChatFromJson(json);
}

@JsonSerializable()
class Message {
  final Author author;
  final MessageContent content;
  final DateTime sentDateTimeUtc;

  Message(this.author, this.content, this.sentDateTimeUtc);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

@JsonSerializable()
class PrivateChat {
  final String id;
  final Author recipient1;
  final Author recipient2;
  final Message lastMessage;

  PrivateChat(this.id, this.recipient1, this.recipient2, this.lastMessage);

  factory PrivateChat.fromJson(Map<String, dynamic> json) => _$PrivateChatFromJson(json);
}

@JsonSerializable()
class MessageContent {
  final String text;

  MessageContent(this.text);

  factory MessageContent.fromJson(Map<String, dynamic> json) => _$MessageContentFromJson(json);
}

@JsonSerializable()
class Author {
  final String name;
  final String id;
  final String gender;
  final DateTime lastOnline;

  Author(this.name, this.id, this.gender, this.lastOnline);

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

extension GetAllChatsResponseExtension on GetAllChatsResponse {
  domain.GetAllChatsDetailsResult toDomain() {
    return domain.GetAllChatsDetailsResult.success(
      details: domain.AllChatsDetails(
        locationChat: domain.LocationChat(
          currentlyOnline: locationChat.currentlyOnline,
          distanceMeters: locationChat.distanceMeters,
          lastMessage: locationChat.lastMessage.toDomain(),
        ),
        privateChats: privateChats.map((PrivateChat chat) {
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

extension MessageExtension on Message {
  domain.Message toDomain() {
    return domain.Message(
      content: domain.MessageContent(text: content.text),
      author: author.toDomain(),
      sentDateTime: sentDateTimeUtc.toUtc(),
    );
  }
}

extension AuthorExtension on Author {
  domain.Author toDomain() {
    return domain.Author(
      id: id,
      name: name,
      gender: getGenderByCodeOrElse(gender, Gender.cat),
      lastOnline: lastOnline,
    );
  }
}
