import 'package:flutter/material.dart';

class MensagemSolicitacaoServico extends StatelessWidget {
  final String nomeUsuario;
  const MensagemSolicitacaoServico({Key? key, required this.nomeUsuario})
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
        "Saudações $nomeUsuario, uma nova solicitação de serviço chegou para você, da uma olhada.",
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
