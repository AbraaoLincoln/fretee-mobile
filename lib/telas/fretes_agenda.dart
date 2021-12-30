import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class FretesAgendados extends StatelessWidget {
  const FretesAgendados({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fretes Agendados"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: _construirListaDeFretesAgendeados(),
      ),
    );
  }

  Widget _construirListaDeFretesAgendeados() {
    int qtdFretesAgendados = 1;

    if (qtdFretesAgendados > 0) {
      return Column(
        children: [_proximoFreteDestaque(), ..._proximoFretes()],
      );
    } else {
      return const Center(child: Text("Nenhum Frete Agendado."));
    }
  }

  Widget _proximoFreteDestaque() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.black),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _construirTextInfoFrete(
                  "Valor", "R\$ 80", Colors.white70, Colors.white),
              _construirTextInfoFrete(
                  "Dia", "10/12/2021", Colors.white70, Colors.white),
              _construirTextInfoFrete(
                  "Hora", "14:45", Colors.white70, Colors.white)
            ],
          ),
          _construirTextInfoFreteComIcon("Origem", "Rua tal, Natal/RN",
              Colors.white70, Colors.white, Colors.white),
          _construirTextInfoFreteComIcon("Destino", "Rua ali, Extremoz/RN",
              Colors.white70, Colors.white, Colors.white)
        ]));
  }

  Widget _construirTextInfoFrete(
      String label, String valor, Color labelColor, Color valorColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, color: labelColor),
        ),
        Text(
          valor,
          style: TextStyle(
              fontSize: 22, color: valorColor, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _construirTextInfoFreteComIcon(String label, String valor,
      Color labelColor, Color valorColor, Color iconColor) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: labelColor),
            ),
            Text(
              valor,
              style: TextStyle(
                  fontSize: 18, color: valorColor, fontWeight: FontWeight.bold),
            )
          ],
        )),
        SizedBox(
          width: 40,
          child: Icon(
            Icons.location_pin,
            color: iconColor,
          ),
        )
      ],
    );
  }

  List<Widget> _proximoFretes() {
    List<Widget> freetsAgendados = [];

    freetsAgendados.add(_proximoFreteNormal());
    freetsAgendados.add(_proximoFreteNormal());

    return freetsAgendados;
  }

  Widget _proximoFreteNormal() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _construirTextInfoFrete(
                  "Valor", "R\$ 80", Colors.grey.shade600, Colors.black),
              _construirTextInfoFrete(
                  "Dia", "10/12/2021", Colors.grey.shade600, Colors.black),
              _construirTextInfoFrete(
                  "Hora", "14:45", Colors.grey.shade600, Colors.black)
            ],
          ),
          _construirTextInfoFreteComIcon("Origem", "Rua tal, Natal/RN",
              Colors.grey.shade600, Colors.black, Colors.black),
          _construirTextInfoFreteComIcon("Destino", "Rua ali, Extremoz/RN",
              Colors.grey.shade600, Colors.black, Colors.black)
        ]));
  }
}
