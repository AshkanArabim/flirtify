import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flirtify/pages/home.dart';
import 'package:flirtify/pages/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    demoProjectId: "demo-project-id",

    // (https://firebase.google.com/docs/flutter/setup?platform=android#initialize-firebase)
    // uncomment line below to use the production project
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    // only activeates in debug mode
    try {
      // firestore emulator
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      // auth emulator
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const Home();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
