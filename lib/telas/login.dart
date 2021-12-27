import 'package:flutter/material.dart';
import 'package:fretee_mobile/telas/busca.dart';
import './cadastro_usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: 700,
      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Fretee",
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: _textoSaudacao(),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
                decoration: InputDecoration(
                    labelText: "Nome de Usuário",
                    labelStyle: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0)))),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.bold),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 55,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuscaPrestadoresServico()),
                );
              },
              child: Text("Entrar", style: TextStyle(fontSize: 20)),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey.shade800),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 55,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroUsuario()),
                  );
                },
                child: Text("Cadastra-se", style: TextStyle(fontSize: 20)),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade800),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )))),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Opa, esqueci a senha",
              style: TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
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
}
