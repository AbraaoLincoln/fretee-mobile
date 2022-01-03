import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/telas/comun/fretee_api.dart';
import 'package:fretee_mobile/telas/comun/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:fretee_mobile/telas/home/home.dart';
import './cadastro_usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomeUsuarioController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

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
                          borderRadius: BorderRadius.circular(50.0))),
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
                      )),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _senhaController,
                  validator: (value) {
                    if (value!.isEmpty) return "Insira a senha cadastrada";
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
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "username": _nomeUsuarioController.text,
          "password": _senhaController.text
        });

    switch (response.statusCode) {
      case 200:
        var jsonBody = json.decode(response.body);
        FreteeApi.accessToken = jsonBody["access_token"];
        FreteeApi.refreshToken = jsonBody["refresh_token"];
        Usuario.usuarioLogado = Usuario(_nomeUsuarioController.text);
        break;
      case 403:
        return false;
        break;
    }

    return true;
  }
}
