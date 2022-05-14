import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'app/chat_app.dart';
import 'core/data/config_repository.dart';
import 'core/data/user_repository.dart';
import 'core/domain/avatar_provider.dart';
import 'firebase_options.dart';
import 'utils/chat_user_converter.dart';

final ChatUserConverter chatUserConverter = ChatUserConverter();
final UserRepository userRepository = UserRepository(chatUserConverter);
final AvatarProvider avatarProvider = AvatarProvider();
final Logger logger = Logger();
final FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
final ConfigRepository configRepository = ConfigRepository(logger, firebaseRemoteConfig);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configRepository.initialize();
  runApp(const ChatApp());
}
