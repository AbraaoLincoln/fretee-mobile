import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/business/solicitar_servico_info.dart';
import 'package:http/http.dart' as http;
import 'package:fretee_mobile/ui/cadastros/cadastro_prestador_servico.dart';
import 'package:fretee_mobile/ui/cadastros/cadastro_usuario.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/ui/login/login.dart';

class PerfilFragmento extends StatefulWidget {
  const PerfilFragmento({Key? key}) : super(key: key);

  @override
  _PerfilFragmentoState createState() => _PerfilFragmentoState();
}

class _PerfilFragmentoState extends State<PerfilFragmento> {
  Map<String, dynamic>? _userInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [_construirUsuarioInfo(), _construirMenuConfig()],
      ),
    );
  }

  Widget _construirUsuarioInfo() {
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
      child: _construirUsuarioInfoWhenReady(),
    );
  }

  Widget _getUsuario() {
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(FreteeApi.getUriUsuarioFoto(),
                headers: {
                  HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
                },
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, object, stackTrace) =>
                    const Text("Erro ao recuperar a imagem do usuario"))),
        Text(
          _userInfo!["nomeCompleto"] ?? "Nome nao informado",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _maisInfoUsuario() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _contruirMaisInfoUsuario("Reputacao",
              _userInfo!["reputacao"].toString(), Icons.star, Colors.amber, 3),
          _contruirMaisInfoUsuario(
              "Usa o app desde",
              _userInfo!["dataCriacao"] ?? "99/99/9999",
              Icons.calendar_today_rounded,
              Colors.black,
              20),
          _contruirMaisInfoUsuario(
              "Fretes",
              _userInfo!["fretesRealizados"].toString(),
              Icons.library_add_check_sharp,
              Colors.green.shade900,
              30)
        ],
      ),
    );
  }

  Widget _contruirMaisInfoUsuario(String label, String valor, IconData icon,
      Color iconColor, double padding) {
    return Container(
      padding: EdgeInsets.only(left: padding),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            children: [
              Icon(icon, color: iconColor),
              Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    valor,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _construirMenuConfig() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            _ContruirInfoPrestadorServico(),
            _ContruirItemMenuPerfil()
          ],
        ));
  }

  Widget _ContruirInfoPrestadorServico() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: const Icon(Icons.receipt),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: const Text("Cadastra-se como \n Prestador de Serviço",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroPrestadorServico()),
                );
              },
              child: const Text("Cadastra-se"),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(190, 10)))
        ],
      ),
    );
  }

  Widget _ContruirItemMenuPerfil() {
    return Expanded(
        child: Column(
      children: [
        _ContruirItemMenu("Editar Informações", "Editar", Icons.edit, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroUsuario()),
          );
        }, 145, 10),
        _ContruirItemMenu("Sair do App", "Sair", Icons.logout, () {
          FreteeApi.accessToken = "";
          FreteeApi.refreshToken = "";
          SolicitacaoServicoInfo.infoAtual = SolicitacaoServicoInfo.vazio();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
              (route) => false);
        }, 145, 0)
      ],
    ));
  }

  Widget _ContruirItemMenu(String label, String botaoLabel, IconData icon,
      void Function() callbackOnTap, double height, double marginBottom) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: marginBottom),
      padding: const EdgeInsets.all(10),
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: Icon(icon),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          TextButton(
              onPressed: callbackOnTap,
              child: Text(botaoLabel),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(150, 1)))
        ],
      ),
    );
  }

  FutureBuilder<void> _construirUsuarioInfoWhenReady() {
    return FutureBuilder<void>(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const SizedBox(
                  height: 180,
                  child: Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ));
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar informações do usuario",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Column(
                  children: [_getUsuario(), _maisInfoUsuario()],
                );
              }
          }
        },
        future: _getUsuarioInfo());
  }

  Future<void> _getUsuarioInfo() async {
    var response = await http.get(FreteeApi.getUriUsuarioInfo(),
        headers: {HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()});

    switch (response.statusCode) {
      case HttpStatus.ok:
        _userInfo = await json.decode(response.body);
        break;
      case HttpStatus.forbidden:
        log("foddiden");
        _userInfo = _getUserInfoPlaceholder();
        break;
      default:
        _userInfo = _getUserInfoPlaceholder();
    }
  }

  Map<String, dynamic> _getUserInfoPlaceholder() {
    Map<String, dynamic> userInfoTemp = Map();

    userInfoTemp["nomeCompleto"] = "Nome Sobrenome";
    userInfoTemp["reputacao"] = "0";
    userInfoTemp["dataCriacao"] = "99/99/9999";
    userInfoTemp["fretesRealizados"] = "0";

    return userInfoTemp;
  }
}
