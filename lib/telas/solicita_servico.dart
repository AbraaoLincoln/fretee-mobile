import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'dart:io';
//import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SolicitarServico extends StatefulWidget {
  const SolicitarServico({Key? key}) : super(key: key);

  @override
  _SolicitarServicoState createState() => _SolicitarServicoState();
}

class _SolicitarServicoState extends State<SolicitarServico> {
  late String _nomePrestadorServico = "Guilherme Pedro";
  late double _reputacaoPrestadorServico = 4.5;
  late double __distanciaPrestadorServico = 3.2;
  late double __veiculoComprimento = 1.887;
  late double __veiculoAltura = 1.339;
  late double __veiculoLargura = 1.089;
  late String _origem = "Rua tal, Natal/RN";
  late String _destino = "Rua ali, Extremoz/RN";
  TextEditingController _diaController = TextEditingController();
  TextEditingController _horaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Busca"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _construirPrestadorServicoInfo(),
            _construirVeiculoInfo(),
            _construirServicoInfo(),
            _construirButonEnviarSolicitacao()
          ],
        ),
      ),
    );
  }

  Widget _construirPrestadorServicoInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "imagens/user_male.png",
              fit: BoxFit.cover,
              width: 100,
              height: 80,
            )),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _nomePrestadorServico,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(children: [
                Row(children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(_reputacaoPrestadorServico.toString())
                ]),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red.shade700,
                    ),
                    Text("$__distanciaPrestadorServico km")
                  ]),
                )
              ]),
            )
          ]),
        ))
      ]),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]),
    );
  }

  Widget _construirVeiculoInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 300,
      child: Column(
        children: [
          Expanded(
              child: Image.asset(
            "imagens/pampa1.jpg",
            fit: BoxFit.cover,
          )),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _construirTextInfoVeiculo(
                    "Comprimento", __veiculoComprimento.toString()),
                _construirTextInfoVeiculo("Altura", __veiculoAltura.toString()),
                _construirTextInfoVeiculo(
                    "Largura", __veiculoLargura.toString())
              ],
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          border: Border.all(color: Colors.grey.shade400)),
    );
  }

  Widget _construirTextInfoVeiculo(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          "$valor mm",
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _construirServicoInfo() {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _construirTextInfoServico("Origem", _origem, Icons.location_pin, 1),
            Divider(
              height: 20,
              color: Colors.grey.shade600,
            ),
            _construirTextInfoServico(
                "Destino", _destino, Icons.location_pin, 1),
            Divider(
              height: 20,
              color: Colors.grey.shade600,
            ),
            _construirSelecionarDiaEHora(),
            Divider(
              height: 20,
              color: Colors.grey.shade600,
            ),
            _construirTextInfoServico(
                "Descrição da Carga", "", Icons.library_books_sharp, 4),
            Divider(
              height: 20,
              color: Colors.grey.shade600,
            ),
            _construirTextInfoServico(
                "Precisa de Ajudante ?", "", Icons.supervised_user_circle, 1)
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400)));
  }

  Widget _construirTextInfoServico(
      String label, String valor, IconData? icon, int qtdLinhas) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                initialValue: valor,
                maxLines: qtdLinhas,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    label: RichText(
                        text: TextSpan(
                            text: label,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18))),
                    border: InputBorder.none,
                    //isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0)))),
        SizedBox(width: 50, child: Icon(icon ?? Icons.warning, size: 25))
      ],
    );
  }

  Widget _construirSelecionarDiaEHora() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextFormField(
              onTap: () async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2022));

                if (date != null) {
                  _diaController.text = DateFormat('dd-MM-yyyy').format(date);
                }

                setState(() {});
              },
              controller: _diaController,
              readOnly: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                  labelText: "Dia",
                  border: InputBorder.none,
                  //isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0))),
        ),
        Expanded(
          child: TextFormField(
              onTap: () async {
                var time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());

                if (time != null) {
                  _horaController.text = time.format(context);
                }

                setState(() {});
              },
              controller: _horaController,
              readOnly: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                  labelText: "Hora",
                  border: InputBorder.none,
                  //isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0))),
        ),
        const SizedBox(width: 50, child: Icon(Icons.av_timer))
      ],
    );
  }

  Widget _construirButonEnviarSolicitacao() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 55,
      width: 400,
      child: TextButton(
          onPressed: () {},
          child:
              const Text("Enviar Solicitação", style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )))),
    );
  }
}
