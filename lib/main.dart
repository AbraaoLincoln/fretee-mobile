import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/home/home.dart';
import 'ui/login/login.dart';

//Receive the message whe apps is in the background
// Future<void> backgroundMessage(RemoteMessage message) async {
//   log("background message");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  Widget home;
  bool usuarioAutenticado = false;

  if (usuarioAutenticado) {
    home = Home();
  } else {
    home = Login();
  }

  runApp(MaterialApp(
    home: home,
  ));
}
