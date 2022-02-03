import 'package:flutter/material.dart';

class MensagemSolicitacaoServico extends StatelessWidget {
  final String nomeUsuario;
  final String? message;
  const MensagemSolicitacaoServico(
      {Key? key, required this.nomeUsuario, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getMensagem();
  }

  Widget _getMensagem() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Text(
        message ?? "Ola $nomeUsuario, da uma olhada na notificação.",
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
