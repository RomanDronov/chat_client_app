import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/chat_app.dart';
import 'data/user_repository.dart';
import 'firebase_options.dart';
import 'utils/chat_user_converter.dart';

final ChatUserConverter chatUserConverter = ChatUserConverter();
final UserRepository userRepository = UserRepository(chatUserConverter);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}
