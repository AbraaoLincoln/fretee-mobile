import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:http/http.dart' as http;

class FretesAgendadosFragmento extends StatefulWidget {
  const FretesAgendadosFragmento({Key? key}) : super(key: key);

  @override
  _FretesAgendadosFragmentoState createState() =>
      _FretesAgendadosFragmentoState();
}

class _FretesAgendadosFragmentoState extends State<FretesAgendadosFragmento> {
  late List<dynamic> _fretes;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: _construirListaDeFretesAgendeados(),
    );
  }

  FutureBuilder<void> _construirListaDeFretesAgendeados() {
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
                  child: _construirFretesAgendeados(),
                );
              }
          }
        },
        future: _getFretes());
  }

  Future<void> _getFretes() async {
    http.Response response;

    do {
      response = await http.get(FreteeApi.getUriFretesAgendados(), headers: {
        HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
      });

      if (response.statusCode == HttpStatus.forbidden) {
        FreteeApi.refreshAccessToken(context);
      }
    } while (response.statusCode == HttpStatus.forbidden);

    if (response.statusCode == HttpStatus.ok) {
      _fretes = json.decode(response.body);
    } else {
      _fretes = [];
      log("Nao foi possivei recuperar os fretes agendados");
      log(response.statusCode.toString());
    }
  }

  Widget _construirFretesAgendeados() {
    if (_fretes.isNotEmpty) {
      return Column(
        children: [_proximoFreteDestaque(_fretes[0]), ..._proximoFretes()],
      );
    } else {
      return Container(
        //color: Colors.red,
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.calendar_today,
              size: 100,
            ),
            Center(
                child: Text(
              "Você não tem fretes agendados no momento",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ))
          ],
        ),
      );
    }
  }

  Widget _proximoFreteDestaque(Map<String, dynamic>? frete) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.black),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _construirTextInfoFrete("Valor", "R\$ ${frete!["preco"]}",
                  Colors.white70, Colors.white),
              _construirTextInfoFrete(
                  "Dia", frete["data"], Colors.white70, Colors.white),
              _construirTextInfoFrete(
                  "Hora", frete["hora"], Colors.white70, Colors.white)
            ],
          ),
          _construirTextInfoFreteComIcon("Origem", frete["origem"],
              Colors.white70, Colors.white, Colors.white),
          _construirTextInfoFreteComIcon("Destino", frete["destino"],
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

    // freetsAgendados.add(_proximoFreteNormal(null));
    // freetsAgendados.add(_proximoFreteNormal(null));
    // freetsAgendados.add(_proximoFreteNormal(null));
    // freetsAgendados.add(_proximoFreteNormal(null));

    for (int i = 1; i < _fretes.length; i++) {
      freetsAgendados.add(_proximoFreteNormal(_fretes[i]));
    }

    return freetsAgendados;
  }

  Widget _proximoFreteNormal(Map<String, dynamic>? frete) {
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
              _construirTextInfoFrete("Valor", "R\$ ${frete!["preco"]}",
                  Colors.grey.shade600, Colors.black),
              _construirTextInfoFrete(
                  "Dia", frete["data"], Colors.grey.shade600, Colors.black),
              _construirTextInfoFrete(
                  "Hora", frete["hora"], Colors.grey.shade600, Colors.black)
            ],
          ),
          _construirTextInfoFreteComIcon("Origem", frete["origem"],
              Colors.grey.shade600, Colors.black, Colors.black),
          _construirTextInfoFreteComIcon("Destino", frete["destino"],
              Colors.grey.shade600, Colors.black, Colors.black)
        ]));
  }
}
