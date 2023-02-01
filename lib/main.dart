// ignore_for_file: prefer_const_constructors, unnecessary_new, unused_label, unused_import

import 'package:flutter/material.dart';
import 'package:sayit/card.dart';
import 'package:sayit/pages/login.dart';
import 'package:sayit/pages/main.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sayit/sayit.dart';
import 'firebase_options.dart';

FirebaseFirestore? db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = FirebaseFirestore.instanceFor(
      app: await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ));
  runApp(SayItApp());
}

//Durumlu widget
class SayItApp extends StatefulWidget {
  const SayItApp({super.key});

  @override
  State<SayItApp> createState() => _SayItApp();
}

SayIt? app;

class _SayItApp extends State<SayItApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Debug yazısını kaldırır
      title: 'Say it',
      home: LoginPage(),
      //routes: {'/cardListPage': (context) => MainPage()},
    );
  }
}
