import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/avaliacao/item_avaliacao.dart';

class AvaliacaoUsuario extends StatefulWidget {
  final List<CriterioAvalicao> criterios;
  final String usuarioSendoAvaliado;
  const AvaliacaoUsuario(
      {Key? key, required this.criterios, required this.usuarioSendoAvaliado})
      : super(key: key);

  @override
  _AvaliacaoUsuarioState createState() => _AvaliacaoUsuarioState();
}

class _AvaliacaoUsuarioState extends State<AvaliacaoUsuario> {
  late final int numeroDeCriteioDeAvaliacao;
  late final List<CriterioAvalicao> criterios;
  late final String usuarioSendoAvaliado;
  Map<String, double> itensDeAvaliacaoNota = {};

  @override
  void initState() {
    super.initState();

    criterios = widget.criterios;
    usuarioSendoAvaliado = widget.usuarioSendoAvaliado;
    numeroDeCriteioDeAvaliacao = criterios.length;
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
            double notaFinal = somaDasNotas / numeroDeCriteioDeAvaliacao;
            log("Nota final: ${notaFinal.toStringAsFixed(1)}");
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
  const AvaliacaoContratante({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvaliacaoUsuario(
        criterios: _getCriteirosDeAvaliacao(),
        usuarioSendoAvaliado: "Contratante");
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
  const AvaliacaoPrestadorServico({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvaliacaoUsuario(
        criterios: _getCriteirosDeAvaliacao(),
        usuarioSendoAvaliado: "Prestador de Servico");
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
