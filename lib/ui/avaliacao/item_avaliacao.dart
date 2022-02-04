import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/avaliacao/estrela.dart';

class ItemAvalicao extends StatefulWidget {
  final String label;
  final String descricao;
  final void Function(String itemLabel, double nota)? informarNota;
  const ItemAvalicao(
      {Key? key,
      required this.label,
      required this.descricao,
      this.informarNota})
      : super(key: key);

  @override
  _ItemAvalicaoState createState() => _ItemAvalicaoState();
}

class _ItemAvalicaoState extends State<ItemAvalicao> {
  late String label;
  late String descricao;
  late List<Estrela> estrelas;
  final int numeroDeEstrelas = 5;
  int indexUltimaEstrelaTap = 0;
  double nota = 0;

  @override
  void initState() {
    super.initState();

    label = widget.label;
    descricao = widget.descricao;

    estrelas = [
      for (int i = 0; i < numeroDeEstrelas; i++)
        Estrela(
            estadoEstrela: EstadoEstrela.vazia,
            onTapCallback: _atualizarNumeroDeEstrelasSelecionadas,
            id: i)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _construirLabel(),
          _construirDescricao(),
          _constuirEstrelas()
        ],
      ),
    );
  }

  Widget _construirLabel() {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  Widget _construirDescricao() {
    return Text(
      descricao,
      style: TextStyle(color: Colors.grey.shade600),
    );
  }

  Widget _constuirEstrelas() {
    return Row(children: estrelas);
  }

  void _atualizarNumeroDeEstrelasSelecionadas(
      int indexAtual, EstadoEstrela estadoEstrela) {
    estrelas = [];

    for (int i = 0; i < indexAtual; i++) {
      estrelas.add(Estrela(
          estadoEstrela: EstadoEstrela.cheia,
          onTapCallback: _atualizarNumeroDeEstrelasSelecionadas,
          id: i));
    }

    if (indexUltimaEstrelaTap > indexAtual) {
      estrelas.add(Estrela(
          estadoEstrela: EstadoEstrela.cheia,
          onTapCallback: _atualizarNumeroDeEstrelasSelecionadas,
          id: indexAtual));
      _atualizarNota(indexAtual, EstadoEstrela.cheia);
    } else {
      estrelas.add(Estrela(
          estadoEstrela: _getEstadoApos(estadoEstrela),
          onTapCallback: _atualizarNumeroDeEstrelasSelecionadas,
          id: indexAtual));
      _atualizarNota(indexAtual, _getEstadoApos(estadoEstrela));
    }
    indexUltimaEstrelaTap = indexAtual;

    for (int i = indexAtual + 1; i < numeroDeEstrelas; i++) {
      estrelas.add(Estrela(
          estadoEstrela: EstadoEstrela.vazia,
          onTapCallback: _atualizarNumeroDeEstrelasSelecionadas,
          id: i));
    }

    if (widget.informarNota != null) widget.informarNota!(label, nota);
    setState(() {});
  }

  EstadoEstrela _getEstadoApos(EstadoEstrela estadoEstrela) {
    switch (estadoEstrela) {
      case EstadoEstrela.vazia:
        return EstadoEstrela.meia;
      case EstadoEstrela.meia:
        return EstadoEstrela.cheia;
      case EstadoEstrela.cheia:
        return EstadoEstrela.vazia;
    }
  }

  void _atualizarNota(int index, EstadoEstrela estadoEstrela) {
    nota = index + _getValorDoEstado(estadoEstrela);
    log("$label: $nota");
  }

  double _getValorDoEstado(EstadoEstrela estadoEstrela) {
    switch (estadoEstrela) {
      case EstadoEstrela.vazia:
        return 0;
      case EstadoEstrela.meia:
        return 0.5;
      case EstadoEstrela.cheia:
        return 1;
    }
  }
}
