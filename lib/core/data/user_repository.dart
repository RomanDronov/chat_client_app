import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/chat_user.dart';
import '../../models/gender.dart';
import '../../utils/chat_user_converter.dart';
import 'sign_in_result.dart';

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
      (element) => element.id == user.uid,
    );
  }

  Future<SignInResult> signIn(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return const SignInResult.success();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return const SignInResult.invalidEmail();
        case 'user-not-found':
          return const SignInResult.userNotFound();
        case 'wrong-password':
          return const SignInResult.wrongPassword();
        default:
          return const SignInResult.unknownFailure();
      }
    }
  }

  Future<ChatUser> registerUser(String email, String password, String name) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = credential.user;
    if (user == null) {
      return Future.error('User was not registered!');
    }
    await _storeUserInfoInFirestore(name, email, user.uid);
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

  Future<void> updateGender({required Gender gender}) async {
    final ChatUser currentUser = await getCurrentUser(isForce: true);
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('users').doc(currentUser.id).set(
      {
        'gender': gender.name,
      },
      SetOptions(merge: true),
    );
    await getCurrentUser(isForce: true);
  }

  Future<void> updateDistance({required int distance}) async {
    final ChatUser currentUser = await getCurrentUser(isForce: true);
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('users').doc(currentUser.id).set(
      {
        'distance': distance,
      },
      SetOptions(merge: true),
    );
    await getCurrentUser(isForce: true);
  }

  Future<void> _storeUserInfoInFirestore(
    String name,
    String email,
    String userId,
  ) async {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'id': userId,
      'gender': Gender.cat.name,
    });
  }

  
}
