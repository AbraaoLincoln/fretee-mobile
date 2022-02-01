import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/utils/http_utils.dart';
import 'package:fretee_mobile/business/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:fretee_mobile/ui/home/home.dart';
import '../../ui/cadastros/cadastro_usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: 700,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      color: Colors.black,
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Fretee",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: _textoSaudacao(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Nome de Usuário",
                      hintStyle: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      errorStyle: const TextStyle(height: 0)),
                  controller: _nomeUsuarioController,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Insira o nome do usuario cadastro";
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Senha",
                      hintStyle: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorStyle: const TextStyle(height: 0)),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _senhaController,
                  validator: (value) {
                    if (value!.isEmpty) return "Insira a senha";
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 55,
                child: TextButton(
                  onPressed: () async {
                    var form = _formKey.currentState;
                    if (!form!.validate()) return;
                    var loginSucess = await _login();

                    if (loginSucess) _loadHome();
                  },
                  child: const Text("Entrar", style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade800),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ))),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 55,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CadastroUsuario()),
                      );
                    },
                    child: const Text("Cadastra-se",
                        style: TextStyle(fontSize: 20)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade800),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        )))),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  "Opa, esqueci a senha",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )),
    )));
  }

  Widget _textoSaudacao() {
    DateTime now = DateTime.now();
    String saudacao;
    double fontSize = 24;

    if (now.hour <= 12) {
      saudacao = "Bom Dia";
    } else if (now.hour > 12 && now.hour < 18) {
      saudacao = "Boa Tarde";
    } else {
      saudacao = "Boa Noite";
    }

    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: saudacao,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
      TextSpan(
          text:
              ", informe suas credenciais para ter acesso a sua conta ou cadastra-se.",
          style: TextStyle(fontSize: fontSize))
    ]));
  }

  void _loadHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (route) => false);
  }

  Future<bool> _login() async {
    var response = await http.post(FreteeApi.getLoginUri(),
        headers: {
          HttpHeaders.contentTypeHeader: HttpMediaType.FORM_URLENCODED,
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "username": _nomeUsuarioController.text,
          "password": _senhaController.text
        });

    switch (response.statusCode) {
      case HttpStatus.ok:
        var jsonBody = json.decode(response.body);
        FreteeApi.accessToken = jsonBody["access_token"];
        FreteeApi.refreshToken = jsonBody["refresh_token"];
        Usuario.logado.nomeUsuario = _nomeUsuarioController.text;
        break;
      case HttpStatus.forbidden:
        log("forbidden...");
        final snackBar = SnackBar(
          content: const Text('Nome de usuário ou senha invalido'),
          action: SnackBarAction(
              label: "ok",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
          duration: const Duration(days: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
    }

    return true;
  }
}
