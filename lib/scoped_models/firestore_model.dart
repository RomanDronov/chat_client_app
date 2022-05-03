import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/chat_user.dart';

mixin FirestoreModel on Model {
  Future<List<ChatUser>> getAllUsers() async {
    final firestoreInstance = FirebaseFirestore.instance;

    List<ChatUser> allUsers = [];

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestoreInstance.collection('users').get();

    for (var result in querySnapshot.docs) {
      final Map<String, dynamic> data = result.data();
      allUsers.add(
        ChatUser(
          name: data['name'],
          chatID: data['userid'],
          phoneNumber: data['phone'],
        ),
      );
    }

    return allUsers;
  }
}
