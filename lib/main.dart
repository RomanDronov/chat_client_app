import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/chat_app.dart';
import 'core/data/config_repository.dart';
import 'core/data/user_repository.dart';
import 'core/domain/avatar_provider.dart';
import 'core/domain/location/location_service.dart';
import 'feature/all_chats/data/all_chats_repository.dart';
import 'feature/all_chats/domain/all_chats_service.dart';
import 'firebase_options.dart';
import 'utils/chat_user_converter.dart';

final ChatUserConverter chatUserConverter = ChatUserConverter();
final UserRepository userRepository = UserRepository(chatUserConverter);
final AvatarProvider avatarProvider = AvatarProvider();
final Logger logger = Logger();
final FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
final ConfigRepository configRepository = ConfigRepository(logger, firebaseRemoteConfig);
final AllChatsRepository allChatsRepository = AllChatsRepository(configRepository);
final AllChatsService allChatsService = AllChatsService(userRepository, allChatsRepository);
final LocationService locationService = LocationService(logger);
late final SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configRepository.initialize();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const ChatApp());
}
