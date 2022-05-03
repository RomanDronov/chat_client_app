import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'firebase_options.dart';
import 'scoped_models/app_model.dart';
import 'screens/startup/start_up_screen.dart';

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
    return ScopedModel(
      model: AppModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartUpScreen(),
      ),
    );
  }
}
