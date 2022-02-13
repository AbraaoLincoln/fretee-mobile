import 'package:flutter/material.dart';

class InfoUsuario extends StatelessWidget {
  final Image userImage;
  final Map<String, dynamic> userInfo;
  const InfoUsuario({Key? key, required this.userImage, required this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informacoes do Usuario"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: _construirInfoUsuario(),
      ),
    );
  }

  Widget _construirInfoUsuario() {
    return Column(children: [_getImageAndNomeCompleto(), _getInfoUsuario()]);
  }

  Widget _getImageAndNomeCompleto() {
    return Column(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(50), child: userImage),
        Text(
          userInfo["nomeCompleto"] ?? "Nome nao informado",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _getInfoUsuario() {
    List<Widget> informacoesDoUsuario = [
      _constuirInfo("Nome usuario", userInfo["nomeUsuario"]),
      _constuirInfo("Telefone", userInfo["telefone"]),
      _constuirInfo("Usa o app desde", userInfo["dataCriacao"]),
      _constuirInfo("Reputacao contratante",
          userInfo["reputacao"].toStringAsFixed(1), Icons.star, Colors.amber),
      _constuirInfo(
          "Fretes contratados",
          userInfo["numeroDeFretesContratados"].toString(),
          Icons.library_add_check_sharp,
          Colors.green.shade900),
    ];

    if (userInfo["prestadorServico"] != null) {
      informacoesDoUsuario.add(_constuirInfo(
          "Reputacao prestador servico",
          userInfo["prestadorServico"]["reputacao"].toStringAsFixed(1),
          Icons.star,
          Colors.amber));
      informacoesDoUsuario.add(_constuirInfo(
          "Servicos prestados",
          userInfo["prestadorServico"]["numeroDeFretesRealizados"].toString(),
          Icons.library_add_check_sharp,
          Colors.green.shade900));
    }

    return Column(children: informacoesDoUsuario);
  }

  Widget _constuirInfo(String label, String valor,
      [IconData? icon, Color? color]) {
    Widget valorWidget;
    TextStyle textStyle = const TextStyle(fontSize: 20);

    if (icon != null) {
      valorWidget = Row(
        children: [
          Text(
            valor,
            style: textStyle,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Icon(
              icon,
              color: color,
            ),
          )
        ],
      );
    } else {
      valorWidget = Text(
        valor,
        style: textStyle,
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label, style: textStyle), valorWidget],
          ),
          Divider(
            height: 5,
            color: Colors.grey.shade600,
          )
        ],
      ),
    );
  }
}
