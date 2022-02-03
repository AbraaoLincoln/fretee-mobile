import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/business/veiculo_info.dart';
import 'package:fretee_mobile/ui/comun/fragments/botoes_aceita_recusa.dart';
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
  const InfoFrete({Key? key, required this.frete, required this.visao})
      : super(key: key);

  @override
  _InfoFreteState createState() => _InfoFreteState();
}

class _InfoFreteState extends State<InfoFrete> {
  late String visao;
  Map<String, dynamic>? frete;
  Map<String, dynamic>? usuarioInfo;
  final VeiculoInfo _veiculo = VeiculoInfo();

  @override
  void initState() {
    super.initState();

    visao = widget.visao;
    frete = widget.frete;
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
        _construirBotoesFinalizarECancelar(context)
      ]);
    } else {
      return Column(children: [
        UsuarioInfo(usuarioInfo: frete!["contratanteNomeUsuario"]),
        ServicoInfo(
          freteInfo: frete!,
          withShadow: true,
        ),
        _construirBotoesFinalizarECancelar(context)
      ]);
    }
  }

  Future<void> _getAdicionaInfo() async {
    await _getVeiculoInfo();

    if (visao == Visao.contratante) {
      usuarioInfo =
          await _getUsuarioInfo(frete!["prestadorServicoNomeUsuario"]);
    } else {
      usuarioInfo = await _getUsuarioInfo(frete!["contratanteNomeUsuario"]);
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

  Widget _construirBotoesFinalizarECancelar(BuildContext context) {
    return BotoesAceitaRecusar(
      acceptButtonLabel: "Concluido",
      acceptCallback: _getAcceptCallback(context),
      rejectButtonLabel: "Cancelar",
      rejectCallback: _getRejectCallback(context),
    );
  }

  Future<int> Function() _getAcceptCallback(BuildContext context) {
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

  Future<int> Function() _getRejectCallback(BuildContext context) {
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
