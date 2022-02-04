import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/business/status_frete.dart';
import 'package:fretee_mobile/business/veiculo_info.dart';
import 'package:fretee_mobile/ui/avaliacao/avaliacao_usuario.dart';
import 'package:fretee_mobile/ui/comun/custom_dialog.dart';
import 'package:fretee_mobile/ui/comun/fragments/info_veiculo.dart';
import 'package:fretee_mobile/ui/comun/fragments/servico_info.dart';
import 'package:fretee_mobile/ui/comun/fragments/usuario_info.dart';
import 'package:fretee_mobile/ui/comun/visao.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/utils/http_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoFrete extends StatefulWidget {
  final String visao;
  final Map<String, dynamic>? frete;
  final int? freteId;
  const InfoFrete({Key? key, this.frete, required this.visao, this.freteId})
      : super(key: key);

  @override
  _InfoFreteState createState() => _InfoFreteState();
}

class _InfoFreteState extends State<InfoFrete> {
  late String visao;
  Map<String, dynamic>? frete;
  late final int? freteId;
  Map<String, dynamic>? usuarioInfo;
  final VeiculoInfo _veiculo = VeiculoInfo();

  @override
  void initState() {
    super.initState();

    visao = widget.visao;
    frete = widget.frete;
    freteId = widget.freteId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Informações do frete"),
          backgroundColor: Colors.black,
        ),
        body: _construirFreteInfo());
  }

  FutureBuilder<void> _construirFreteInfo() {
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
                return GestureDetector(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: _construirFreteInfoDeAcordoComAVisao(),
                  ),
                );
              }
          }
        },
        future: _getAdicionaInfo());
  }

  Widget _construirFreteInfoDeAcordoComAVisao() {
    if (visao == Visao.contratante) {
      return Column(children: [
        UsuarioInfo(usuarioInfo: usuarioInfo!),
        InfoVeiculo(
            nomeUsuarioPrestadorServico: frete!["prestadorServicoNomeUsuario"],
            veiculo: _veiculo),
        ServicoInfo(
          freteInfo: frete!,
          withShadow: true,
        ),
        _construirBotoes()
      ]);
    } else {
      return Column(children: [
        UsuarioInfo(usuarioInfo: usuarioInfo!),
        ServicoInfo(
          freteInfo: frete!,
          withShadow: true,
        ),
        _construirBotoes()
      ]);
    }
  }

  Future<void> _getAdicionaInfo() async {
    if (frete == null && freteId != null) {
      frete = await _getFreteInfo(freteId!);
    }

    await _getVeiculoInfo();

    if (visao == Visao.contratante) {
      usuarioInfo =
          await _getUsuarioInfo(frete!["prestadorServicoNomeUsuario"]);
    } else {
      usuarioInfo = await _getUsuarioInfo(frete!["contratanteNomeUsuario"]);
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

  Future<void> _getVeiculoInfo() async {
    http.Response response;

    do {
      response = await http.get(
          FreteeApi.getUriPrestadoresServicoVeiculoInfo(
              frete!["prestadorServicoNomeUsuario"]),
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

  Widget _construirBotoes() {
    if (frete!["status"] == StatusFrete.contratanteFinalizou ||
        frete!["status"] == StatusFrete.prestadorServicoFinalizou) {
      return _construirBotoesConfirmarENegar(context);
    } else {
      return _construirBotoesFinalizarECancelar(context);
    }
  }

  Widget _construirBotoesFinalizarECancelar(BuildContext context) {
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
                          callbackRequest: _getAcceptCallback(),
                          successHandler: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Avaliacao(frete: frete!),
                                ),
                                (route) => false);
                          },
                        ));
              },
              child:
                  const Text("Frete Concluido", style: TextStyle(fontSize: 20)),
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
                          callbackRequest: _getRejectCallback(),
                        ));
              },
              child: const Text("Cancelar", style: TextStyle(fontSize: 20)),
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

  Widget _construirBotoesConfirmarENegar(BuildContext context) {
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
                          callbackRequest: _getAcceptCallback(),
                          successHandler: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Avaliacao(frete: frete!),
                                ),
                                (route) => false);
                          },
                        ));
              },
              child: const Text("Confirmar", style: TextStyle(fontSize: 20)),
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
                          callbackRequest: _getRejectCallback(),
                        ));
              },
              child: const Text("Negar", style: TextStyle(fontSize: 20)),
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

  Future<int> Function() _getAcceptCallback() {
    return () async {
      http.Response response;

      do {
        response = await http.put(FreteeApi.getUriFinalizarFrete(frete!["id"]),
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

  Future<int> Function() _getRejectCallback() {
    return () async {
      http.Response response;

      do {
        response = await http.put(FreteeApi.getUriCancelarFrete(frete!["id"]),
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
