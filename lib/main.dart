import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Login(),
    ));

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
            child: Text(
              "Fretee",
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              _textoSaudacao(),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
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
                    ))),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 55,
            child: TextButton(
              onPressed: () {},
              child: Text("Entrar"),
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
                onPressed: () {},
                child: Text("Cadastra-se"),
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

  String _textoSaudacao() {
    return "Boa Tarde, informe suas credenciais para ter acesso a sua conta ou cadastra-se.";
  }
}
