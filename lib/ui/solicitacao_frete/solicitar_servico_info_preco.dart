import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class SolicitarServicoPreco extends StatefulWidget {
  const SolicitarServicoPreco({Key? key}) : super(key: key);

  @override
  _SolicitarServicoPrecoState createState() => _SolicitarServicoPrecoState();
}

class _SolicitarServicoPrecoState extends State<SolicitarServicoPreco> {
  late final String _nomeUsuario = "Cicrana";
  late final double _reputacaoUsuario = 4.1;
  late final double __distanciaUsuario = 3.2;
  late final String _origem = "Rua tal, Natal/RN";
  late final String _destino = "Rua ali, Extremoz/RN";
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
        children: [_construirUsuarioInfo(), _getServicoInfo()],
      ),
    );
  }

  Widget _construirUsuarioInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "imagens/user_female.png",
              fit: BoxFit.cover,
              width: 100,
              height: 80,
            )),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _nomeUsuario,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(children: [
                Row(children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(
                    _reputacaoUsuario.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  )
                ]),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red.shade700,
                    ),
                    Text("$__distanciaUsuario km",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ]),
                )
              ]),
            )
          ]),
        ))
      ]),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    );
  }

  Widget _getServicoInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _construirTextInfoServico("Origem", _origem, Icons.location_pin),
          Divider(
            height: 20,
            color: Colors.grey.shade600,
          ),
          _construirTextInfoServico("Destino", _destino, Icons.location_pin),
          Divider(
            height: 20,
            color: Colors.grey.shade600,
          ),
          _construirTextDataServico(),
          Divider(
            height: 20,
            color: Colors.grey.shade600,
          ),
          _construirTextInfoServico(
              "Descrição da Carga",
              "Assim mesmo, o aumento do diálogo entre os diferentes setores produtivos maximiza as possibilidades por conta dos métodos utilizados na avaliação de resultados",
              Icons.library_books_sharp)
        ],
      ),
    );
  }

  Widget _construirTextInfoServico(String label, String valor, IconData? icon) {
    return Row(
      children: [
        Expanded(child: _construirTextInfoFretre(label, valor)),
        SizedBox(width: 50, child: Icon(icon ?? Icons.warning, size: 25))
      ],
    );
  }

  Widget _construirTextDataServico() {
    return Row(
      children: [
        Expanded(child: _construirTextInfoFretre("Dia", "10/12/2021")),
        Expanded(child: _construirTextInfoFretre("Hora", "14:45")),
        const SizedBox(width: 50, child: Icon(Icons.av_timer))
      ],
    );
  }

  Widget _construirTextInfoFretre(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        SizedBox(
            child: Text(
          valor,
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ))
      ],
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
}
