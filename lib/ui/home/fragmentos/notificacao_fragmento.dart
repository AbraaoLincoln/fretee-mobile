import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fretee_mobile/business/status_frete.dart';
import 'package:fretee_mobile/comun/fretee_api.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/solicitar_servico_info_preco.dart';

class NotificacaoFragmento extends StatefulWidget {
  const NotificacaoFragmento({Key? key}) : super(key: key);

  @override
  _NotificacaoFragmentoState createState() => _NotificacaoFragmentoState();
}

class _NotificacaoFragmentoState extends State<NotificacaoFragmento> {
  late List<dynamic> _notificacoes;
  bool atualizando = false;

  @override
  Widget build(BuildContext context) {
    return _construirListaDeNotificacoes();
  }

  Widget _construirNotificacao(
      String label, IconData icon, Color iconColor, void Function() callback) {
    return InkWell(
        onTap: callback,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, size: 50, color: iconColor),
              _construirNotificacaoText(
                  label, "Toque aqui para mais informações.")
            ],
          ),
        ));
  }

  Widget _construirNotificacaoText(String label, String valor) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            valor,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }

  FutureBuilder<void> _construirListaDeNotificacoes() {
    return FutureBuilder<void>(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              if (!atualizando) {
                return const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Linear progress indicator',
                  ),
                );
              } else {
                return const Text("");
              }
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
                if (_notificacoes.isNotEmpty) {
                  return RefreshIndicator(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(10),
                      itemCount: _notificacoes.length,
                      itemBuilder: _buildItemList,
                    ),
                    onRefresh: _refreshListaDeNotificacoes,
                  );
                } else {
                  return RefreshIndicator(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Center(
                                child: Text(
                                    "Você não tem nenhuma notificação no momento")),
                          )),
                      onRefresh: _refreshListaDeNotificacoes);
                }
              }
          }
        },
        future: _fetchListaDeNotificacoes());
  }

  Future<void> _fetchListaDeNotificacoes() async {
    http.Response response;

    do {
      response = await http.get(FreteeApi.getUriListaNotificacoes(), headers: {
        HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
      });

      if (response.statusCode == HttpStatus.forbidden) {
        FreteeApi.refreshAccessToken(context);
      }
    } while (response.statusCode == HttpStatus.forbidden);

    switch (response.statusCode) {
      case HttpStatus.ok:
        _notificacoes = await json.decode(response.body);
        break;
      default:
        log(response.statusCode.toString());
        _notificacoes = [];
        break;
    }
  }

  Future<void> _refreshListaDeNotificacoes() async {
    setState(() {
      atualizando = true;
    });
  }

  Widget _buildItemList(BuildContext context, int index) {
    Widget notificacao = _construirNotificacao(
        "Status não definido", Icons.not_interested, Colors.black, () {});

    if (_notificacoes[index] != null &&
        _notificacoes[index]["status"] != null) {
      return _buildNotificacao(_notificacoes[index]["status"]);
    }

    return notificacao;
  }

  Widget _buildNotificacao(String status) {
    switch (status) {
      case StatusFrete.solicitando:
        return _construirNotificacao(
            "Solicitação De Serviço", Icons.email, Colors.black, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SolicitarServicoPreco()),
          );
        });
      case StatusFrete.solicitacaoRecusada:
        return _construirNotificacao(
            "Solicitação Recusada", Icons.error, Colors.red.shade800, () {});
      case StatusFrete.precoInformado:
        return _construirNotificacao("Preço Informado", Icons.monetization_on,
            Colors.amber.shade400, () {});
      case StatusFrete.agendado:
        return _construirNotificacao("O frete foi marcado", Icons.check_circle,
            Colors.green.shade500, () {});
      case StatusFrete.cancelado:
        return _construirNotificacao(
            "Frete cancelado", Icons.error, Colors.red.shade800, () {});
      case StatusFrete.finalizado:
        return _construirNotificacao("Frete concluido", Icons.check_circle,
            Colors.green.shade500, () {});
      default:
        return _construirNotificacao(
            "Status não definido", Icons.not_interested, Colors.black, () {});
    }
  }

  Widget _construirListaStaticaDeNotificacoes() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _construirNotificacao(
                "Solicitação De Serviço", Icons.email, Colors.black, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SolicitarServicoPreco()),
              );
            }),
            _construirNotificacao("O frete foi marcado", Icons.check_circle,
                Colors.green.shade500, () {
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CadastroUsuario()),
              // );
            }),
            _construirNotificacao(
                "Preço Informado", Icons.monetization_on, Colors.amber.shade400,
                () {
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CadastroUsuario()),
              // );
            }),
            _construirNotificacao(
                "Solicitação Enviada", Icons.send, Colors.blue.shade600, () {
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CadastroUsuario()),
              // );
            }),
            _construirNotificacao(
                "Solicitação Recusada", Icons.error, Colors.red.shade800, () {
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CadastroUsuario()),
              // );
            })
          ],
        ));
  }
}
