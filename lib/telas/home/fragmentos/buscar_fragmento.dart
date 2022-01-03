import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/telas/comun/device_location.dart';
import 'package:fretee_mobile/telas/comun/fretee_api.dart';
import 'package:fretee_mobile/telas/comun/usuario.dart';
import 'package:fretee_mobile/telas/solicita_servico.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

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
          margin: const EdgeInsets.only(top: 20, bottom: 10),
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
    await _getDeviceLocation();

    if (!Usuario.usuarioLogado!.location.gpsEnable) {
      _prestadoresDeServico = [];
      _prestadoresDeServico.add(const Center(
        child: Text("O Gps não está ativado"),
      ));
      return;
    }

    if (!Usuario.usuarioLogado!.location.permissionGranted) {
      _prestadoresDeServico = [];
      _prestadoresDeServico.add(const Center(
        child: Text("O app não tem permissão de usar o gps do dispositivo."),
      ));
      return;
    }

    _prestadoresDeServico =
        _construirCardResultado(await _buscarPrestadoresDeServicoProximos());
  }

  List<Widget> _construirCardResultado(
      List<dynamic> prestadoresDeServicoProximos) {
    List<Widget> prestadoresDeServico = [];

    for (var prestadorServico in prestadoresDeServicoProximos) {
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
                        child: Text(
                          prestadorServico["nomeCompleto"]!,
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
                                Text(prestadorServico["reputacao"]! == 0
                                    ? "Novo"
                                    : prestadorServico["reputacao"]!.toString())
                              ]),
                              Row(children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red.shade700,
                                ),
                                Text("${prestadorServico["distancia"]!} km")
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
                    headers: {"Authorization": FreteeApi.getaccessToken()},
                    fit: BoxFit.cover,
                  ),
                ),
              )
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

  Future<List<dynamic>> _buscarPrestadoresDeServicoProximos() async {
    var response =
        await http.get(FreteeApi.getUriPrestadoresServicoProximo(), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": FreteeApi.getaccessToken()
    });

    switch (response.statusCode) {
      case 200:
        var prestadoresServico = await json.decode(response.body);
        return prestadoresServico;
        break;
      case 403:
        print("forddiden");
        break;
    }

    return [];
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {});

    return null;
  }

  Future<void> _getDeviceLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Usuario.usuarioLogado!.location = DeviceLocation.gpsEnable(false);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Usuario.usuarioLogado!.location =
            DeviceLocation.permissionGranted(false);
      }
    }

    _locationData = await location.getLocation();

    Usuario.usuarioLogado!.location =
        DeviceLocation(_locationData.latitude, _locationData.longitude);
  }
}
