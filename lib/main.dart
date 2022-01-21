import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/home/home.dart';
import 'ui/login/login.dart';

void main() {
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
