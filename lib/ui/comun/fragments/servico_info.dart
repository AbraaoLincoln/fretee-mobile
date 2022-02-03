import 'package:flutter/material.dart';

class ServicoInfo extends StatelessWidget {
  final Map<String, dynamic> freteInfo;
  final List<Map<String, dynamic>>? camposAdicionas;
  final bool? withShadow;
  const ServicoInfo(
      {Key? key,
      required this.freteInfo,
      this.camposAdicionas,
      this.withShadow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (withShadow != null && withShadow!) {
      return _getServicoInfoComSambra();
    } else {
      return _getServicoInfo();
    }
  }

  Widget _getServicoInfoComSambra() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
      child: Column(
        children: _construirInformacoesDoServico(),
      ),
    );
  }

  Widget _getServicoInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: _construirInformacoesDoServico(),
      ),
    );
  }

  List<Widget> _construirInformacoesDoServico() {
    Widget divider = Divider(
      height: 20,
      color: Colors.grey.shade600,
    );
    List<Widget> informacoes = [
      _construirTextInfoServico(
          "Origem", freteInfo["origem"], Icons.location_pin),
      divider,
      _construirTextInfoServico(
          "Destino", freteInfo["destino"], Icons.location_pin),
      divider,
      _construirTextDataServico(),
      divider,
      _construirTextInfoServico("Descrição da Carga",
          freteInfo["descricaoCarga"], Icons.library_books_sharp)
    ];

    if (camposAdicionas != null && camposAdicionas!.isNotEmpty) {
      for (var element in camposAdicionas!) {
        informacoes.add(divider);
        informacoes.add(_construirTextInfoServico(
            element["label"], element["valor"].toString(), element["icon"]));
      }
    }

    return informacoes;
  }

  Widget _construirTextInfoServico(String label, String valor, IconData? icon) {
    return Row(
      children: [
        Expanded(child: _construirTextInfoFrete(label, valor)),
        SizedBox(width: 50, child: Icon(icon ?? Icons.warning, size: 25))
      ],
    );
  }

  Widget _construirTextDataServico() {
    return Row(
      children: [
        Expanded(child: _construirTextInfoFrete("Dia", freteInfo["data"])),
        Expanded(child: _construirTextInfoFrete("Hora", freteInfo["hora"])),
        const SizedBox(width: 50, child: Icon(Icons.av_timer))
      ],
    );
  }

  Widget _construirTextInfoFrete(String label, String valor) {
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
}
