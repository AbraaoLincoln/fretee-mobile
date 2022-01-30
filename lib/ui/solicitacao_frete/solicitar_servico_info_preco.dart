import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/mensagem.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/servico_info.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/usuario_info.dart';
import 'package:http/http.dart' as http;

class SolicitarServicoPreco extends StatefulWidget {
  const SolicitarServicoPreco({Key? key}) : super(key: key);

  @override
  _SolicitarServicoPrecoState createState() => _SolicitarServicoPrecoState();
}

class _SolicitarServicoPrecoState extends State<SolicitarServicoPreco> {
  final TextEditingController _precoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar Serviço"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _getMensagem(),
            _construirFreteInfo(),
            _construirPrecoServico(),
            _construirBotoes()
          ],
        ),
      ),
    );
  }

  Widget _getMensagem() {
    String nomeUsuario = "Fulano";
    return MensagemSolicitacaoServico(nomeUsuario: nomeUsuario);
  }

  Widget _construirFreteInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
      child: Column(
        children: [
          UsuarioInfo(usuarioInfo: getUsuarioPlaceholder()),
          ServicoInfo(freteInfo: getFretePlaceholder())
        ],
      ),
    );
  }

  Widget _construirPrecoServico() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(top: 20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
              child: Text(
            "Valor do Frete:",
            style: TextStyle(fontSize: 20),
          )),
          SizedBox(
            width: 100,
            child: TextFormField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  // hintText: "R\$",
                  // hintStyle: TextStyle(color: Colors.white),
                  prefix: Text(
                    "R\$",
                    style: TextStyle(color: Colors.white),
                  ),
                  fillColor: Colors.black,
                  filled: true,
                ),
                controller: _precoController),
          )
        ],
      ),
    );
  }

  Widget _construirBotoes() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 55,
          child: TextButton(
              onPressed: () {},
              child:
                  const Text("Informar Preço", style: TextStyle(fontSize: 20)),
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
              onPressed: () {},
              child: const Text("Recusar Solicitação",
                  style: TextStyle(fontSize: 20)),
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

  Map<String, dynamic> getUsuarioPlaceholder() {
    Map<String, dynamic> placeholder = {};

    placeholder["nomeUsuario"] = "Nome Sobrenome";
    placeholder["reputacaoUsuario"] = 4.5;
    placeholder["distancia"] = 3.1;

    return placeholder;
  }

  Map<String, dynamic> getFretePlaceholder() {
    Map<String, dynamic> placeholder = {};

    placeholder["origem"] = "redinha";
    placeholder["destino"] = "lagoa";
    placeholder["data"] = "2021-02-20";
    placeholder["hora"] = "10:00";
    placeholder["descricaoCarga"] = "teste testando";

    return placeholder;
  }
}
