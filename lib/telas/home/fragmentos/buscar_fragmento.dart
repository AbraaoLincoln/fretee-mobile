import 'package:flutter/material.dart';
import 'package:fretee_mobile/telas/solicita_servico.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class BuscaPrestadoresServicoFragmento extends StatefulWidget {
  const BuscaPrestadoresServicoFragmento({Key? key}) : super(key: key);

  @override
  _BuscaPrestadoresServicoFragmentoState createState() =>
      _BuscaPrestadoresServicoFragmentoState();
}

class _BuscaPrestadoresServicoFragmentoState
    extends State<BuscaPrestadoresServicoFragmento> {
  late List<Widget> _prestadoresDeServico;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ConstruirFormOrigemDestino(),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Text(
            "Resultado",
            style: TextStyle(fontSize: 20),
          ),
        ),
        _construirListaDePrestadoresDeServicoProximos()
      ],
    );
  }

  Widget _ConstruirFormOrigemDestino() {
    return Container(
      width: 380,
      height: 113,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Row(children: [
            SizedBox(
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Origem",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              ),
              width: 305,
              height: 30,
            ),
            const SizedBox(
              child: Icon(Icons.location_pin),
              width: 50,
              height: 30,
            )
          ]),
          const Divider(
            height: 25,
            color: Colors.black,
          ),
          Row(children: [
            SizedBox(
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Destino",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
              ),
              width: 305,
              height: 30,
            ),
            const SizedBox(
              child: Icon(Icons.location_pin),
              width: 50,
              height: 30,
            )
          ])
        ],
      ),
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

  FutureBuilder<void> _construirListaDePrestadoresDeServicoProximos() {
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
                return Expanded(
                    child: RefreshIndicator(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(10),
                    itemCount: _prestadoresDeServico.length,
                    itemBuilder: _buildItemList,
                  ),
                  onRefresh: _refresh,
                ));
              }
          }
        },
        future: _getResource());
  }

  Future<void> _getResource() async {
    await Future.delayed(const Duration(seconds: 2));

    _prestadoresDeServico = _construirCardResultado();
  }

  List<Widget> _construirCardResultado() {
    List<Widget> prestadoresDeServico = [];

    for (int i = 0; i < 10; i++) {
      Widget x = InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SolicitarServico()),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                width: 220,
                height: 100,
                color: Colors.grey.shade200,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text(
                          "Fulano de Tal",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 120,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: const [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text("4.7")
                              ]),
                              Row(children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red.shade700,
                                ),
                                Text("2.3 km")
                              ])
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text("Online recente"),
                      )
                    ]),
              ),
              Expanded(
                  child: Image.asset(
                "imagens/pampa1.jpg",
                fit: BoxFit.cover,
              )),
            ],
          ),
        ),
      );

      prestadoresDeServico.add(x);
    }

    return prestadoresDeServico;
  }

  Widget _buildItemList(context, index) {
    return _prestadoresDeServico[index];
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {});

    return null;
  }
}
