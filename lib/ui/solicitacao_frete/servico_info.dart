import 'package:flutter/material.dart';

class ServicoInfo extends StatelessWidget {
  final Map<String, dynamic> freteInfo;
  const ServicoInfo({Key? key, required this.freteInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getServicoInfo();
  }

  Widget _getServicoInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _construirTextInfoServico(
              "Origem", freteInfo["origem"], Icons.location_pin),
          Divider(
            height: 20,
            color: Colors.grey.shade600,
          ),
          _construirTextInfoServico(
              "Destino", freteInfo["destino"], Icons.location_pin),
          Divider(
            height: 20,
            color: Colors.grey.shade600,
          ),
          _construirTextDataServico(),
          Divider(
            height: 20,
            color: Colors.grey.shade600,
          ),
          _construirTextInfoServico("Descrição da Carga",
              freteInfo["descricaoCarga"], Icons.library_books_sharp)
        ],
      ),
    );
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
