import '../models/chat_user.dart';

class ChatUserConverter {
  ChatUser convertOrNull(Map<String, dynamic> data) {
    return ChatUser(
      name: data['name'],
      chatID: data['userid'],
      phoneNumber: data['email'],
    );
  }
}
