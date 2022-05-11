import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'data/user_repository.dart';
import 'firebase_options.dart';
import 'screens/startup/start_up_screen.dart';
import 'utils/chat_user_converter.dart';

final ChatUserConverter chatUserConverter = ChatUserConverter();
final UserRepository userRepository = UserRepository(chatUserConverter);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartUpScreen(),
    );
  }
}
