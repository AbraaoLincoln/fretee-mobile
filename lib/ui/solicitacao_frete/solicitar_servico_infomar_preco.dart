import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/comun/custom_dialog.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/utils/placeholders.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/mensagem.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/servico_info.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/usuario_info.dart';
import 'package:http/http.dart' as http;

class SolicitarServicoInformarPreco extends StatefulWidget {
  final int freteId;
  final String nomeUsuarioPresadorServico;
  const SolicitarServicoInformarPreco(
      {Key? key,
      required this.freteId,
      required this.nomeUsuarioPresadorServico})
      : super(key: key);

  @override
  _SolicitarServicoPrecoState createState() => _SolicitarServicoPrecoState();
}

class _SolicitarServicoPrecoState extends State<SolicitarServicoInformarPreco> {
  final TextEditingController _precoController = TextEditingController();
  late Map<String, dynamic> _freteInfo;
  late Map<String, dynamic> _contratanteInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar Serviço"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _construirInfoServico(),
    );
  }

  FutureBuilder<void> _construirInfoServico() {
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
                if (_freteInfo.isNotEmpty && _contratanteInfo.isNotEmpty) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _getMensagem(),
                        _construirFreteInfo(),
                        _construirPrecoServico(),
                        _construirBotoes()
                      ],
                    ),
                  );
                } else {
                  return const Text(
                      "Nao foi possivel recuperar as informacoes do frete");
                }
              }
          }
        },
        future: _getServicoInfo());
  }

  Widget _getMensagem() {
    return MensagemSolicitacaoServico(
        nomeUsuario: _contratanteInfo["nomeUsuario"]);
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
          UsuarioInfo(usuarioInfo: _contratanteInfo),
          ServicoInfo(freteInfo: _freteInfo)
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
              onPressed: () {
                Map<String, dynamic> body = {
                  "freteId": widget.freteId,
                  "preco": _precoController.text
                };

                showDialog(
                    context: context,
                    builder: (context) => MyCustomDialog(
                          statusCodeSuccess: HttpStatus.ok,
                          callbackRequest: () async {
                            http.Response response;

                            do {
                              response = await http.put(
                                  FreteeApi.getUriInformarPreco(widget.freteId),
                                  headers: {
                                    HttpHeaders.contentTypeHeader:
                                        ContentType.json.toString(),
                                    HttpHeaders.authorizationHeader:
                                        FreteeApi.getAccessToken()
                                  },
                                  body: json.encode(body));

                              if (response.statusCode == HttpStatus.forbidden) {
                                FreteeApi.refreshAccessToken(context);
                              }
                            } while (
                                response.statusCode == HttpStatus.forbidden);

                            return response.statusCode;
                          },
                        ));
              },
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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => MyCustomDialog(
                          statusCodeSuccess: HttpStatus.ok,
                          callbackRequest: () async {
                            http.Response response;

                            do {
                              response = await http.put(
                                  FreteeApi.getUriRecusarSolicitacao(
                                      widget.freteId),
                                  headers: {
                                    HttpHeaders.authorizationHeader:
                                        FreteeApi.getAccessToken()
                                  });

                              if (response.statusCode == HttpStatus.forbidden) {
                                FreteeApi.refreshAccessToken(context);
                              }
                            } while (
                                response.statusCode == HttpStatus.forbidden);

                            return response.statusCode;
                          },
                        ));
              },
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

  Future<void> _getServicoInfo() async {
    _freteInfo = await _getFreteInfo(widget.freteId);
    if (_freteInfo.isNotEmpty &&
        _freteInfo["prestadorServicoNomeUsuario"] != null) {
      _contratanteInfo =
          await _getUsuarioInfo(_freteInfo["contratanteNomeUsuario"]);
    }
  }

  Future<Map<String, dynamic>> _getFreteInfo(int freteId) async {
    http.Response response;

    do {
      response = await http.get(FreteeApi.getUriFreteInfo(freteId), headers: {
        HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
      });

      if (response.statusCode == HttpStatus.forbidden) {
        FreteeApi.refreshAccessToken(context);
      }
    } while (response.statusCode == HttpStatus.forbidden);

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      log("Nao foi possivel recuperar as informacoes do frete");
      log(response.statusCode.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> _getUsuarioInfo(String nomeUsuario) async {
    http.Response response;

    do {
      response = await http.get(
          FreteeApi.getUriUsuarioInfoPorNomeUsuario(nomeUsuario),
          headers: {
            HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
          });

      if (response.statusCode == HttpStatus.forbidden) {
        FreteeApi.refreshAccessToken(context);
      }
    } while (response.statusCode == HttpStatus.forbidden);

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      log("Nao foi possivel recuperar as informacoes do usuario");
      log(response.statusCode.toString());
      return {};
    }
  }
}
