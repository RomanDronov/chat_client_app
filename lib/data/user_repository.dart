import 'dart:async';

import '../models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/chat_user_converter.dart';

class UserRepository {
  final ChatUserConverter _chatUserConverter;
  final List<ChatUser> cachedUsers = List.empty(growable: true);

  UserRepository(this._chatUserConverter);

  Future<List<ChatUser>> getAllUsers({bool isForce = false}) async {
    if (!isForce && cachedUsers.isNotEmpty) {
      return List.from(cachedUsers, growable: false);
    }
    final List<ChatUser> fetchedUsers = await _fetchUsers();
    cachedUsers.clear();
    cachedUsers.addAll(fetchedUsers);
    return List.from(cachedUsers, growable: false);
  }

  Future<ChatUser> getCurrentUser({bool isForce = false}) async {
    final List<ChatUser> allUsers = await getAllUsers(isForce: isForce);

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Future.error('User is not logged in!');
    }

    return allUsers.firstWhere(
      (element) => element.chatID == user.uid,
    );
  }

  Future<ChatUser> registerUser(String email, String password, String name) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError(print);
    final User? user = credential.user;
    if (user == null) {
      return Future.error('User was not registered!');
    }
    await _storeUserInfoInFirestore(name, email, user.uid, password);
    return getCurrentUser(isForce: true);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<List<ChatUser>> _fetchUsers() async {
    final firestoreInstance = FirebaseFirestore.instance;

    List<ChatUser> allUsers = [];

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestoreInstance.collection('users').get();

    for (final result in querySnapshot.docs) {
      final Map<String, dynamic> data = result.data();
      final ChatUser user = _chatUserConverter.convertOrNull(data);
      allUsers.add(user);
    }

    return allUsers;
  }

  Future<void> _storeUserInfoInFirestore(
    String name,
    String email,
    String userId,
    String password,
  ) async {
    final firestoreInstance = FirebaseFirestore.instance;

    final currentUser = ChatUser(name: name, chatID: userId, phoneNumber: email);

    await firestoreInstance.collection('users').add({
      'name': name,
      'email': email,
      'password': password,
      'userid': userId,
    }).then((value) {
      print(value.id);
    });
  }
}
