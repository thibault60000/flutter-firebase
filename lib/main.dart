import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DOC : https://firebase.flutter.dev/

Future<void> main() async {
  // Prevenir bug android
  WidgetsFlutterBinding.ensureInitialized();
  // Init firebase
  await Firebase.initializeApp();
  // Init app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData.dark(),
      home: const HomePage(title: 'Flutter Firebase'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
    );
  }
}
