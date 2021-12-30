import 'package:flutter/material.dart';
import 'package:fretee_mobile/telas/busca.dart';
import './telas/login.dart';

void main() {
  Widget home;
  bool usuarioAutenticado = true;

  if (usuarioAutenticado) {
    home = BuscaPrestadoresServico();
  } else {
    home = Login();
  }

  runApp(MaterialApp(
    home: home,
  ));
}
