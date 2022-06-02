import '../models/chat_user.dart';
import '../models/gender.dart';

class ChatUserConverter {
  ChatUser convertOrNull(Map<String, dynamic> data) {
    final String name = data['name'] ?? '';
    final String email = data['email'] ?? '';
    final String userId = data['id'] ?? '';
    final String gender = data['gender'] ?? '';
    final int distance = int.tryParse((data['distance'].toString())) ?? 5;
    return ChatUser(
      name: name,
      id: userId,
      email: email,
      gender: Gender.values.firstWhere(
        (element) => element.name == gender,
        orElse: () => Gender.cat,
      ),
      distance: distance
    );
  }
}
