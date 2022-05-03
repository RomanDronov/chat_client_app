import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/chat_user.dart';
import '../screens/all_chats_screen.dart';

mixin AuthenticationModel on Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  ChatUser? currentUser;

  final _codeController = TextEditingController();

  Future registerUser(String mobile, BuildContext context, String name) async {
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((UserCredential result) {
            final User? user = result.user;
            if (user == null) {
              return;
            }
            storeUserInfoInFirestore(name, mobile, user.uid);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AllChatsPage()));
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          //show dialog to take input from the user
          print("Code sent.");

          AuthCredential _credential;
          String smsCode;

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text("Enter SMS Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Done"),
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;

                          smsCode = _codeController.text.trim();

                          _credential = PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsCode);

                          auth.signInWithCredential(_credential).then((UserCredential result) {
                            // store user in firestore
                            storeUserInfoInFirestore(name, mobile, result.user?.uid);

                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => AllChatsPage()));
                          }).catchError((e) {
                            print(e);
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  storeUserInfoInFirestore(name, phone, userId) {
    final firestoreInstance = FirebaseFirestore.instance;

    currentUser = ChatUser(name: name, chatID: userId, phoneNumber: phone);

    firestoreInstance.collection("users").add({
      "name": name,
      "phone": phone,
      "userid": userId,
    }).then((value) {
      print(value.id);
    });
  }
}
