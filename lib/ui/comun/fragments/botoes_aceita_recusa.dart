import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/comun/custom_dialog.dart';

class BotoesAceitaRecusar extends StatelessWidget {
  final Future<int> Function()? acceptCallback;
  final Future<int> Function()? rejectCallback;
  final String? acceptButtonLabel;
  final String? rejectButtonLabel;
  final Map<String, dynamic>? body;

  const BotoesAceitaRecusar(
      {Key? key,
      this.acceptCallback,
      this.rejectCallback,
      this.acceptButtonLabel,
      this.rejectButtonLabel,
      this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _construirBotoes(context);
  }

  Widget _construirBotoes(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 55,
          child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => MyCustomDialog(
                        statusCodeSuccess: HttpStatus.ok,
                        callbackRequest: acceptCallback!));
              },
              child: Text(acceptButtonLabel ?? "Aceitar",
                  style: const TextStyle(fontSize: 20)),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(400, 10))),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 55,
          child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => MyCustomDialog(
                          statusCodeSuccess: HttpStatus.ok,
                          callbackRequest: rejectCallback!,
                        ));
              },
              child: Text(rejectButtonLabel ?? "Recusar",
                  style: const TextStyle(fontSize: 20)),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(400, 10))),
        )
      ],
    );
  }
}
