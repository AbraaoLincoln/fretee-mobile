import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/telas/comun/device_location.dart';
import 'package:fretee_mobile/telas/comun/fretee_api.dart';
import 'package:fretee_mobile/telas/comun/http_utils.dart';
import 'package:fretee_mobile/telas/comun/usuario.dart';
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
  ErroGps erroGps = ErroGps();
  late List<dynamic> _prestadoresDeServico;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //_construiiButaoAbrirFormInfoSolicitarServico(),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text(
            "Fretes Próximos",
            style: TextStyle(fontSize: 20),
          ),
        ),
        _construirListaDePrestadoresDeServicoProximos()
      ],
    );
  }

  Widget _construiiButaoAbrirFormInfoSolicitarServico() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text("Informações do Frete"))
              ],
            ),
            style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                minimumSize: const Size(100, 50))));
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
    await DeviceLocation.getLocation();

    if (!Usuario.logado.location.gpsEnable) {
      _prestadoresDeServico = [];
      erroGps.hasError = true;
      erroGps.widgetShowErro = const Center(
        child: Text("O Gps não está ativado"),
      );
      return;
    }

    if (!Usuario.logado.location.permissionGranted) {
      _prestadoresDeServico = [];
      erroGps.hasError = true;
      erroGps.widgetShowErro = const Center(
        child: Text("O app não tem permissão de usar o gps do dispositivo."),
      );
      return;
    }

    _prestadoresDeServico = await _buscarPrestadoresDeServicoProximos();
  }

  List<Widget> _construirCardResultado(
      List<dynamic> prestadoresDeServicoProximos) {
    List<Widget> prestadoresDeServico = [];

    for (var prestadorServico in prestadoresDeServicoProximos) {
      Widget prestadoreDeServico = InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SolicitarServico()),
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
                        child: Text(
                          prestadorServico["nomeCompleto"] ?? "Nome Sobrenome",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 140,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(prestadorServico["reputacao"] != null
                                    ? (prestadorServico["reputacao"] == 0
                                        ? "Novo"
                                        : prestadorServico["reputacao"]
                                            .toString())
                                    : "0")
                              ]),
                              Row(children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red.shade700,
                                ),
                                Text(
                                    "${prestadorServico["distancia"] ?? "0"} km")
                              ])
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text("Online recente"),
                      )
                    ]),
              ),
              // Expanded(
              //     child: Image.asset(
              //   "imagens/pampa1.jpg",
              //   fit: BoxFit.cover,
              // )),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Image.network(
                    FreteeApi.getUriPrestadoresServicoFotoVeiculo(
                        prestadorServico["nomeUsuario"]),
                    headers: {
                      HttpHeaders.authorizationHeader:
                          FreteeApi.getAccessToken()
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      );

      prestadoresDeServico.add(prestadoreDeServico);
    }

    return prestadoresDeServico;
  }

  Widget _buildItemList(context, index) {
    if (erroGps.hasError) return erroGps.widgetShowErro;
    var prestadorServico = _prestadoresDeServico[index];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SolicitarServico()),
        );
      },
      child: Container(
        height: 200,
        width: 500,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ], borderRadius: BorderRadius.circular(10)),
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SizedBox(
                height: 100,
                child: Image.network(
                  FreteeApi.getUriPrestadoresServicoFotoVeiculo(
                      prestadorServico["nomeUsuario"]),
                  headers: {
                    HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                margin: const EdgeInsets.only(left: 5, top: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ]),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          prestadorServico["nomeCompleto"] ?? "Nome Sobrenome",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        // margin: const EdgeInsets.only(left: 5),
                        width: 150,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(prestadorServico["reputacao"] != null
                                    ? (prestadorServico["reputacao"] == 0
                                        ? "Novo"
                                        : prestadorServico["reputacao"]
                                            .toString())
                                    : "0")
                              ]),
                              Row(children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red.shade700,
                                ),
                                Text(
                                    "${prestadorServico["distancia"] ?? "0"} km")
                              ])
                            ]),
                      )
                    ]))
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> _buscarPrestadoresDeServicoProximos() async {
    var response = await http.get(
        FreteeApi.getUriPrestadoresServicoProximo(
            Usuario.logado.location.latitude,
            Usuario.logado.location.longitude),
        headers: {
          HttpHeaders.contentTypeHeader: HttpMediaType.FORM_URLENCODED,
          HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
        });

    switch (response.statusCode) {
      case HttpStatus.ok:
        var prestadoresServico = await json.decode(response.body);
        return prestadoresServico;
      case HttpStatus.forbidden:
        log("FORBIDDEN...");
        break;
    }

    return [];
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {});
  }
}

class ErroGps {
  bool hasError = false;
  Widget widgetShowErro = const Text("Erro Gps");
}
