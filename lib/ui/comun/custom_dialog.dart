import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/home/home.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:http/http.dart' as http;

class MyCustomDialog extends StatefulWidget {
  final Future<int> Function() callbackRequest;
  final int statusCodeSuccess;
  final void Function()? successHandler;
  final String? successMessage;
  final String? erroMessage;

  const MyCustomDialog(
      {Key? key,
      required this.callbackRequest,
      required this.statusCodeSuccess,
      this.successHandler,
      this.successMessage,
      this.erroMessage})
      : super(key: key);

  @override
  _MyCustomDialogState createState() => _MyCustomDialogState();
}

class _MyCustomDialogState extends State<MyCustomDialog> {
  late int responseStatusCode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Processando",
          textAlign: TextAlign.center,
        ),
        content: _construirMessageRe());
  }

  FutureBuilder<void> _construirMessageRe() {
    return FutureBuilder<void>(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return showResponse();
              }
          }
        },
        future: _doRequest());
  }

  Future<void> _doRequest() async {
    responseStatusCode = await widget.callbackRequest();
  }

  Widget showResponse() {
    if (responseStatusCode == widget.statusCodeSuccess) {
      return _construirResposta(
          widget.successMessage ?? "Operação realizada com sucesso", Icons.send,
          () {
        if (widget.successHandler != null) {
          widget.successHandler!();
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
              (route) => false);
        }
      });
    } else {
      return _construirResposta(
          widget.erroMessage ??
              "Erro ao realizada a operação, statuscode: $responseStatusCode",
          Icons.error, () {
        Navigator.pop(context);
      });
    }
  }

  Widget _construirResposta(
      String msg, IconData icon, void Function() callback) {
    return SizedBox(
      height: 200,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(2, 3),
                ),
              ]),
          child: Icon(
            icon,
            size: 50,
          ),
        ),
        Text(msg, textAlign: TextAlign.center),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              // elevation: 15.0,
              minimumSize: const Size(200, 10)),
          onPressed: callback,
          child: const Text('OK'),
        )
      ]),
    );
  }
}
