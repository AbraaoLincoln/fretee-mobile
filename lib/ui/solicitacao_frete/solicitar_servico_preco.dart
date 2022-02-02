import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/business/usuario.dart';
import 'package:fretee_mobile/ui/comun/custom_dialog.dart';
import 'package:fretee_mobile/ui/comun/visao.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/botoes_aceita_recusa.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/utils/placeholders.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/mensagem.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/servico_info.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/usuario_info.dart';
import 'package:http/http.dart' as http;

class SolicitarServicoPreco extends StatefulWidget {
  final int freteId;
  final Widget Function(
      String visao,
      Map<String, dynamic> freteInfo,
      Map<String, dynamic> usuarioInfo,
      BuildContext context) getWidgetsDeAcordoComAVisao;

  const SolicitarServicoPreco(
      {Key? key,
      required this.freteId,
      required this.getWidgetsDeAcordoComAVisao})
      : super(key: key);

  @override
  _SolicitarServicoPrecoState createState() => _SolicitarServicoPrecoState();
}

class _SolicitarServicoPrecoState extends State<SolicitarServicoPreco> {
  late Map<String, dynamic> _freteInfo;
  late Map<String, dynamic> _contratanteInfo;
  String visao = Visao.contratante;

  // Map<String, dynamic> body = {
  //                 "freteId": widget.freteId,
  //                 "preco": _precoController.text
  //               };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar Serviço"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _construirInfoServico(widget.getWidgetsDeAcordoComAVisao, context),
    );
  }

  FutureBuilder<void> _construirInfoServico(
      Widget Function(String visao, Map<String, dynamic> freteInfo,
              Map<String, dynamic> usuarioInfo, BuildContext context)
          getWidgetsDeAcordoComAVisao,
      BuildContext context) {
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
                    child: getWidgetsDeAcordoComAVisao(
                        visao, _freteInfo, _contratanteInfo, context),
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

  Future<void> _getServicoInfo() async {
    _freteInfo = await _getFreteInfo(widget.freteId);

    if (_freteInfo.isNotEmpty) {
      if (Usuario.logado.nomeUsuario == _freteInfo["contratanteNomeUsuario"]) {
        visao = Visao.contratante;
        _contratanteInfo =
            await _getUsuarioInfo(_freteInfo["prestadorServicoNomeUsuario"]);
      } else {
        visao = Visao.prestadorServico;
        _contratanteInfo =
            await _getUsuarioInfo(_freteInfo["contratanteNomeUsuario"]);
      }
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

class AvaliaPreco extends StatelessWidget {
  final int freteId;

  const AvaliaPreco({Key? key, required this.freteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SolicitarServicoPreco(
      freteId: freteId,
      getWidgetsDeAcordoComAVisao: _getWidgetsDeAcordoComAVisao,
    );
  }

  Widget _getWidgetsDeAcordoComAVisao(
      String visao,
      Map<String, dynamic> freteInfo,
      Map<String, dynamic> usuarioInfo,
      BuildContext context) {
    log("Avaliar Preco Widget");
    if (visao == Visao.prestadorServico) {
      return Column(
        children: [
          _getMensagem(freteInfo["prestadorServicoNomeUsuario"]),
          _construirFreteInfo(visao, freteInfo, usuarioInfo)
        ],
      );
    } else {
      return Column(
        children: [
          _getMensagem(freteInfo["contratanteNomeUsuario"]),
          _construirFreteInfo(visao, freteInfo, usuarioInfo),
          _construirBotoes(context)
        ],
      );
    }
  }

  Widget _getMensagem(String nomeUsuario) {
    return MensagemSolicitacaoServico(nomeUsuario: nomeUsuario);
  }

  Widget _construirFreteInfo(String visao, Map<String, dynamic> freteInfo,
      Map<String, dynamic> usuarioInfo) {
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
          UsuarioInfo(usuarioInfo: usuarioInfo),
          ServicoInfo(
            freteInfo: freteInfo,
            showPreco: visao == Visao.contratante,
          )
        ],
      ),
    );
  }

  Widget _construirBotoes(BuildContext context) {
    return BotoesAceitaRecusar(
      acceptButtonLabel: "Aceitar Preço",
      acceptCallback: _getAcceptCallback(context),
      rejectButtonLabel: "Recusar Preço",
      rejectCallback: _getRejectCallback(context),
    );
  }

  Future<int> Function() _getAcceptCallback(BuildContext context) {
    return () async {
      http.Response response;

      do {
        response = await http.put(FreteeApi.getUriAceitarPreco(freteId),
            headers: {
              HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
            });

        if (response.statusCode == HttpStatus.forbidden) {
          FreteeApi.refreshAccessToken(context);
        }
      } while (response.statusCode == HttpStatus.forbidden);

      return response.statusCode;
    };
  }

  Future<int> Function() _getRejectCallback(BuildContext context) {
    return () async {
      http.Response response;

      do {
        response = await http.put(FreteeApi.getUriRecusarPreco(freteId),
            headers: {
              HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
            });

        if (response.statusCode == HttpStatus.forbidden) {
          FreteeApi.refreshAccessToken(context);
        }
      } while (response.statusCode == HttpStatus.forbidden);

      return response.statusCode;
    };
  }
}

class InformaPreco extends StatefulWidget {
  final int freteId;
  const InformaPreco({Key? key, required this.freteId}) : super(key: key);

  @override
  _InformaPrecoState createState() => _InformaPrecoState();
}

class _InformaPrecoState extends State<InformaPreco> {
  final TextEditingController _precoController = TextEditingController();
  final Map<String, dynamic> body = {};

  @override
  Widget build(BuildContext context) {
    return SolicitarServicoPreco(
      freteId: widget.freteId,
      getWidgetsDeAcordoComAVisao: _getWidgetsDeAcordoComAVisao,
    );
  }

  Widget _getWidgetsDeAcordoComAVisao(
      String visao,
      Map<String, dynamic> freteInfo,
      Map<String, dynamic> usuarioInfo,
      BuildContext context) {
    log("Informar Preco Widget");
    if (visao == Visao.prestadorServico) {
      return Column(
        children: [
          _getMensagem(freteInfo["prestadorServicoNomeUsuario"]),
          _construirFreteInfo(visao, freteInfo, usuarioInfo),
          _construirPrecoServico(),
          _construirBotoes(context)
        ],
      );
    } else {
      return Column(
        children: [
          _getMensagem(freteInfo["contratanteNomeUsuario"]),
          _construirFreteInfo(visao, freteInfo, usuarioInfo),
          _construirBotaoCancelarSolicitacao(context)
        ],
      );
    }
  }

  Widget _getMensagem(String nomeUsuario) {
    return MensagemSolicitacaoServico(nomeUsuario: nomeUsuario);
  }

  Widget _construirFreteInfo(String visao, Map<String, dynamic> freteInfo,
      Map<String, dynamic> usuarioInfo) {
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
          UsuarioInfo(usuarioInfo: usuarioInfo),
          ServicoInfo(
            freteInfo: freteInfo,
            showPreco: visao == Visao.contratante,
          )
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

  Widget _construirBotoes(BuildContext context) {
    return BotoesAceitaRecusar(
      acceptButtonLabel: "Informar Preço",
      acceptCallback: _getAcceptCallback(context),
      rejectButtonLabel: "Recusar Solicitação",
      rejectCallback: _getRejectCallback(context),
      body: body,
    );
  }

  Future<int> Function() _getAcceptCallback(BuildContext context) {
    return () async {
      http.Response response;
      Map<String, dynamic> body = {
        "freteId": widget.freteId,
        "preco": _precoController.text
      };

      do {
        response = await http.put(FreteeApi.getUriInformarPreco(widget.freteId),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.toString(),
              HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
            },
            body: json.encode(body));

        if (response.statusCode == HttpStatus.forbidden) {
          FreteeApi.refreshAccessToken(context);
        }
      } while (response.statusCode == HttpStatus.forbidden);

      return response.statusCode;
    };
  }

  Future<int> Function() _getRejectCallback(BuildContext context) {
    return () async {
      http.Response response;

      do {
        response = await http
            .put(FreteeApi.getUriRecusarSolicitacao(widget.freteId), headers: {
          HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
        });

        if (response.statusCode == HttpStatus.forbidden) {
          FreteeApi.refreshAccessToken(context);
        }
      } while (response.statusCode == HttpStatus.forbidden);

      return response.statusCode;
    };
  }

  Widget _construirBotaoCancelarSolicitacao(BuildContext context) {
    return Container(
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
                            FreteeApi.getUriCancelarSolicitacao(widget.freteId),
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  FreteeApi.getAccessToken()
                            });

                        if (response.statusCode == HttpStatus.forbidden) {
                          FreteeApi.refreshAccessToken(context);
                        }
                      } while (response.statusCode == HttpStatus.forbidden);

                      return response.statusCode;
                    }));
          },
          child: const Text("Cancelar Solicitacao",
              style: TextStyle(fontSize: 20)),
          style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              minimumSize: const Size(400, 10))),
    );
  }
}
