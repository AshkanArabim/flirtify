import 'package:flirtify/pages/chats_page/Chats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    demoProjectId: "demo-project-id",

    // (https://firebase.google.com/docs/flutter/setup?platform=android#initialize-firebase)
    // uncomment line below to use the production project
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Chats(),
    );
  }
}
