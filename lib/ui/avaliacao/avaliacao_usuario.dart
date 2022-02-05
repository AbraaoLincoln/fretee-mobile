import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/business/usuario.dart';
import 'package:fretee_mobile/ui/avaliacao/item_avaliacao.dart';
import 'package:fretee_mobile/ui/comun/custom_dialog.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvaliacaoUsuario extends StatefulWidget {
  final List<CriterioAvalicao> criterios;
  final String usuarioSendoAvaliado;
  final int freteId;
  const AvaliacaoUsuario(
      {Key? key,
      required this.criterios,
      required this.usuarioSendoAvaliado,
      required this.freteId})
      : super(key: key);

  @override
  _AvaliacaoUsuarioState createState() => _AvaliacaoUsuarioState();
}

class _AvaliacaoUsuarioState extends State<AvaliacaoUsuario> {
  late final int numeroDeCriteioDeAvaliacao;
  late final List<CriterioAvalicao> criterios;
  late final String usuarioSendoAvaliado;
  late final int freteId;
  double notaFinal = 0;
  Map<String, double> itensDeAvaliacaoNota = {};

  @override
  void initState() {
    super.initState();

    criterios = widget.criterios;
    usuarioSendoAvaliado = widget.usuarioSendoAvaliado;
    numeroDeCriteioDeAvaliacao = criterios.length;
    freteId = widget.freteId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Avaliação do $usuarioSendoAvaliado"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MenssagemAvaliacao(
              papelSendoAvaliado: usuarioSendoAvaliado,
            ),
            _construirItensDeAvaliacao(),
            _construirBotao()
          ],
        ),
      ),
    );
  }

  Widget _construirItensDeAvaliacao() {
    List<Widget> itensDeAvaliacao = [];

    for (var criterio in criterios) {
      itensDeAvaliacao.add(
        ItemAvalicao(
            label: criterio.label,
            descricao: criterio.descricao,
            informarNota: _atualizarNota),
      );
    }

    return Column(children: itensDeAvaliacao);
  }

  void _atualizarNota(String itemLabel, double nota) {
    itensDeAvaliacaoNota[itemLabel] = nota;
  }

  Widget _construirBotao() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 55,
      child: TextButton(
          onPressed: () {
            double somaDasNotas = 0;
            for (var criterio in criterios) {
              log(itensDeAvaliacaoNota[criterio.label].toString());
              somaDasNotas += itensDeAvaliacaoNota[criterio.label] ?? 0;
            }
            notaFinal = somaDasNotas / numeroDeCriteioDeAvaliacao;
            log("Nota final: ${notaFinal.toStringAsFixed(1)}");

            showDialog(
                context: context,
                builder: (context) => MyCustomDialog(
                    statusCodeSuccess: HttpStatus.ok,
                    callbackRequest: _getAcceptCallback()));
          },
          child:
              const Text("Concluir Avaliação", style: TextStyle(fontSize: 20)),
          style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              minimumSize: const Size(400, 10))),
    );
  }

  Future<int> Function() _getAcceptCallback() {
    return () async {
      http.Response response;

      do {
        response = await http.put(FreteeApi.getUriFinalizarFrete(freteId),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.toString(),
              HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
            },
            body: json.encode({"freteId": freteId, "nota": notaFinal}));

        if (response.statusCode == HttpStatus.forbidden) {
          FreteeApi.refreshAccessToken(context);
        }
      } while (response.statusCode == HttpStatus.forbidden);

      return response.statusCode;
    };
  }
}

class MenssagemAvaliacao extends StatelessWidget {
  final String papelSendoAvaliado;
  const MenssagemAvaliacao({Key? key, required this.papelSendoAvaliado})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: _construirMensage());
  }

  Widget _construirMensage() {
    DateTime now = DateTime.now();
    String saudacao;

    if (now.hour <= 12) {
      saudacao = "Bom Dia";
    } else if (now.hour > 12 && now.hour < 18) {
      saudacao = "Boa Tarde";
    } else {
      saudacao = "Boa Noite";
    }

    return Text(
        "Opa $saudacao, esperamos que você tenha tido uma boa experiencia durante todo o processo, pedimos a você que avalie como foi sua experiencia com o $papelSendoAvaliado.");
  }
}

class CriterioAvalicao {
  late final String label;
  late final String descricao;

  CriterioAvalicao(this.label, this.descricao);
}

class AvaliacaoContratante extends StatelessWidget {
  final int freteId;
  const AvaliacaoContratante({Key? key, required this.freteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvaliacaoUsuario(
      criterios: _getCriteirosDeAvaliacao(),
      usuarioSendoAvaliado: "Contratante",
      freteId: freteId,
    );
  }

  List<CriterioAvalicao> _getCriteirosDeAvaliacao() {
    return [
      CriterioAvalicao("Comunicação",
          "O contratante o tratou com respeito e/ou respondeu as liagações."),
      CriterioAvalicao("Horario", "O contratante respeitou o horario marcado."),
      CriterioAvalicao("Pagamento", "O contratante pagou o acordado.")
    ];
  }
}

class AvaliacaoPrestadorServico extends StatelessWidget {
  final int freteId;
  const AvaliacaoPrestadorServico({Key? key, required this.freteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvaliacaoUsuario(
      criterios: _getCriteirosDeAvaliacao(),
      usuarioSendoAvaliado: "Prestador de Servico",
      freteId: freteId,
    );
  }

  List<CriterioAvalicao> _getCriteirosDeAvaliacao() {
    return [
      CriterioAvalicao("Comunicação",
          "O Prestador de Servico o tratou com respeito e/ou respondeu as liagações."),
      CriterioAvalicao(
          "Horario", "O Prestador de Servico respeitou o horario marcado."),
      CriterioAvalicao("Cuidado Com a Carga",
          "O Prestador de Serviço transportou a carga da forma correta."),
      CriterioAvalicao(
          "Valor do Serviço", "O Prestador de Servico cobrou o acordado.")
    ];
  }
}

class Avaliacao extends StatelessWidget {
  final Map<String, dynamic> frete;
  const Avaliacao({Key? key, required this.frete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Usuario.logado.nomeUsuario == frete["prestadorServicoNomeUsuario"]) {
      return AvaliacaoContratante(freteId: frete["id"]);
    } else {
      return AvaliacaoPrestadorServico(freteId: frete["id"]);
    }
  }
}
