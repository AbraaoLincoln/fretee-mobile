import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fretee_mobile/business/solicitar_servico_info.dart';
import 'package:fretee_mobile/ui/home/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:fretee_mobile/comun/fretee_api.dart';
import 'package:fretee_mobile/comun/http_utils.dart';

class SolicitarServico extends StatefulWidget {
  final dynamic prestadorServico;
  const SolicitarServico({Key? key, this.prestadorServico}) : super(key: key);

  @override
  _SolicitarServicoState createState() => _SolicitarServicoState();
}

class _SolicitarServicoState extends State<SolicitarServico> {
  dynamic prestadorServico;
  final VeiculoInfo _veiculo = VeiculoInfo();

  @override
  void initState() {
    super.initState();

    prestadorServico = widget.prestadorServico;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _construirListaDePrestadoresDeServicoProximos(),
    );
  }

  FutureBuilder<void> _construirListaDePrestadoresDeServicoProximos() {
    return FutureBuilder<void>(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Linear progress indicator',
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
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      _construirPrestadorServicoInfo(),
                      _construirVeiculoInfo(),
                      FormSolicitacaoServico(prestadorServico: prestadorServico)
                    ],
                  ),
                );
              }
          }
        },
        future: _getVeiculoInfo());
  }

  Widget _construirPrestadorServicoInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              FreteeApi.getUriPrestadoresServicoFoto(
                  prestadorServico["nomeUsuario"]),
              headers: {
                HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
              },
              fit: BoxFit.cover,
              width: 100,
              height: 80,
              errorBuilder: (context, object, stackTrace) =>
                  const Text("Erro ao recuperar a imagem do usuario"),
            )),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              prestadorServico["nomeCompleto"] ?? "Nome Sobrenome",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(children: [
                Row(children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(prestadorServico["reputacao"] != null
                      ? (prestadorServico["reputacao"] == 0
                          ? "Novo"
                          : prestadorServico["reputacao"].toString())
                      : "0")
                ]),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red.shade700,
                    ),
                    Text("${prestadorServico["distancia"] ?? "0"} km")
                  ]),
                )
              ]),
            )
          ]),
        ))
      ]),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ]),
    );
  }

  Widget _construirVeiculoInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _construirImagemDoVeiculo(),
          _construirInfoDimensoesVeiculo()
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          border: Border.all(color: Colors.grey.shade400)),
    );
  }

  Widget _construirImagemDoVeiculo() {
    return Expanded(
        child: FittedBox(
      child: Image.network(
          FreteeApi.getUriPrestadoresServicoFotoVeiculo(
              prestadorServico["nomeUsuario"]),
          headers: {
            HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
          },
          errorBuilder: (context, object, stackTrace) =>
              const Text("Erro ao recuperar a imagem do veiculo")),
      fit: BoxFit.fill,
    ));
  }

  Widget _construirInfoDimensoesVeiculo() {
    if (_veiculo.hasErros) {
      return const Center(
        child: Text("Nao foi possivel recuperar os dados do veiculo"),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _construirTextInfoVeiculo(
                "Comprimento", _veiculo.info["comprimento"].toString()),
            _construirTextInfoVeiculo(
                "Altura", _veiculo.info["altura"].toString()),
            _construirTextInfoVeiculo(
                "Largura", _veiculo.info["largura"].toString())
          ],
        ),
      );
    }
  }

  Widget _construirTextInfoVeiculo(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          "$valor mm",
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Map<String, String> getPrestadorServicoPlaceholder() {
    Map<String, String> prestadorServico = {};
    prestadorServico["nome"] = "nome sobrenome";
    prestadorServico["reputacao"] = "4.5";
    prestadorServico["nome"] = "3.2";
    prestadorServico["comprimento"] = "1.887";
    prestadorServico["altura"] = "1.339";
    prestadorServico["largura"] = "1.089";

    return prestadorServico;
  }

  Future<void> _getVeiculoInfo() async {
    if (prestadorServico["nomeUsuario"] == null) {
      log("nome usuario is null");
      return;
    }

    http.Response response;

    do {
      response = await http.get(
          FreteeApi.getUriPrestadoresServicoVeiculoInfo(
              prestadorServico["nomeUsuario"]),
          headers: {
            HttpHeaders.contentTypeHeader: HttpMediaType.FORM_URLENCODED,
            HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
          });

      switch (response.statusCode) {
        case HttpStatus.ok:
          var bodyJson = await json.decode(response.body);
          _veiculo.info = bodyJson;
          _veiculo.hasErros = false;
          break;
        case HttpStatus.forbidden:
          log("Forbidden");
          FreteeApi.refreshAccessToken(context);
          break;
        default:
          log(response.statusCode.toString());
          _veiculo.hasErros = true;
      }
    } while (response.statusCode == HttpStatus.forbidden);
  }
}

class FormSolicitacaoServico extends StatefulWidget {
  final dynamic prestadorServico;
  const FormSolicitacaoServico({Key? key, this.prestadorServico})
      : super(key: key);

  @override
  _FormSolicitacaoServicoState createState() => _FormSolicitacaoServicoState();
}

class _FormSolicitacaoServicoState extends State<FormSolicitacaoServico> {
  final TextEditingController _origemController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _diaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precisaAjudanteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _origemController.text = SolicitacaoServicoInfo.infoAtual.origem;
    _destinoController.text = SolicitacaoServicoInfo.infoAtual.destino;
    _descricaoController.text = SolicitacaoServicoInfo.infoAtual.descricaoCarga;
    _diaController.text = SolicitacaoServicoInfo.infoAtual.dia;
    _horaController.text = SolicitacaoServicoInfo.infoAtual.hora;
  }

  @override
  Widget build(BuildContext context) {
    return _construirServicoInfo();
  }

  Widget _construirServicoInfo() {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _construirTextInfoServico(
                    "Origem", Icons.location_pin, 1, _origemController),
                Divider(
                  height: 20,
                  color: Colors.grey.shade600,
                ),
                _construirTextInfoServico(
                    "Destino", Icons.location_pin, 1, _destinoController),
                Divider(
                  height: 20,
                  color: Colors.grey.shade600,
                ),
                _construirSelecionarDiaEHora(),
                Divider(
                  height: 20,
                  color: Colors.grey.shade600,
                ),
                _construirTextInfoServico("Descrição da Carga",
                    Icons.library_books_sharp, 4, _descricaoController),
                Divider(
                  height: 20,
                  color: Colors.grey.shade600,
                ),
                _construirTextInfoServico(
                    "Precisa de Ajudante ?",
                    Icons.supervised_user_circle,
                    1,
                    _precisaAjudanteController),
              ],
            )),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400))),
        _construirButonEnviarSolicitacao()
      ],
    );
  }

  Widget _construirTextInfoServico(String label, IconData? icon, int qtdLinhas,
      TextEditingController contoller) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                maxLines: qtdLinhas,
                controller: contoller,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    label: RichText(
                        text: TextSpan(
                            text: label,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18))),
                    border: InputBorder.none,
                    //isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0)))),
        SizedBox(width: 50, child: Icon(icon ?? Icons.warning, size: 25))
      ],
    );
  }

  Widget _construirSelecionarDiaEHora() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextFormField(
              onTap: () async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2099));

                if (date != null) {
                  _diaController.text = DateFormat('dd-MM-yyyy').format(date);
                }

                setState(() {});
              },
              controller: _diaController,
              readOnly: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                  labelText: "Dia",
                  border: InputBorder.none,
                  //isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0))),
        ),
        Expanded(
          child: TextFormField(
              onTap: () async {
                var time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());

                if (time != null) {
                  _horaController.text = time.format(context);
                }

                setState(() {});
              },
              controller: _horaController,
              readOnly: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                  labelText: "Hora",
                  border: InputBorder.none,
                  //isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0))),
        ),
        const SizedBox(width: 50, child: Icon(Icons.av_timer))
      ],
    );
  }

  void _atualizarSolicitacaoServicoInfo() {
    SolicitacaoServicoInfo.infoAtual.origem = _origemController.text;
    SolicitacaoServicoInfo.infoAtual.destino = _destinoController.text;
    SolicitacaoServicoInfo.infoAtual.descricaoCarga = _descricaoController.text;
    SolicitacaoServicoInfo.infoAtual.hora = _horaController.text;
    SolicitacaoServicoInfo.infoAtual.dia = _diaController.text;
  }

  Widget _construirButonEnviarSolicitacao() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 55,
      width: 400,
      child: TextButton(
          onPressed: () {
            _atualizarSolicitacaoServicoInfo();
            _solicitarServico();
          },
          child:
              const Text("Enviar Solicitação", style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )))),
    );
  }

  Future<void> _solicitarServico() async {
    var body = json.encode(getSolicitacaiServico());
    showDialog(context: context, builder: (_) => MyDialog(body: body));
  }

  Map<String, String> getSolicitacaiServico() {
    Map<String, String> solicitacaoServico = {};
    solicitacaoServico["origem"] = _origemController.text;
    solicitacaoServico["destino"] = _destinoController.text;
    solicitacaoServico["dia"] = _diaController.text;
    solicitacaoServico["hora"] = _horaController.text;
    solicitacaoServico["descricao"] = _descricaoController.text;
    solicitacaoServico["prestadorServicoNomeUsuario"] =
        this.widget.prestadorServico["nomeUsuario"];
    return solicitacaoServico;
  }
}

class VeiculoInfo {
  bool hasErros = false;
  late Map<String, dynamic> info;
}

class MyDialog extends StatefulWidget {
  final String body;
  final String? successMessage;
  final String? erroMessage;
  const MyDialog(
      {Key? key, required this.body, this.successMessage, this.erroMessage})
      : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late int responseStatusCode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Enviando solicitação"),
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
        future: _solicitarServico(widget.body));
  }

  Future<int> _solicitarServico(String bodyStringfy) async {
    http.Response response;

    do {
      response = await http.post(FreteeApi.getUriSolicitarServico(),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
            HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
          },
          body: bodyStringfy);

      log(response.statusCode.toString());

      if (response.statusCode == HttpStatus.forbidden) {
        FreteeApi.refreshAccessToken(context);
      }
    } while (response.statusCode == HttpStatus.forbidden);

    responseStatusCode = response.statusCode;

    return response.statusCode;
  }

  Widget showResponse() {
    switch (responseStatusCode) {
      case HttpStatus.created:
        return SizedBox(
          height: 100,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.send),
                const Text("Operacao realizada com suscesso"),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                        (route) => false);
                  },
                  child: const Text('OK'),
                )
              ]),
        );
      default:
        return SizedBox(
          height: 110,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.error),
                Text(
                    "Erro ao realizada a operação, statuscode: $responseStatusCode"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                )
              ]),
        );
    }
  }
}
