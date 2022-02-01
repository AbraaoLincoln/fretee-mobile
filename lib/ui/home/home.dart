import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/utils/http_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fretee_mobile/ui/home/fragmentos/buscar_fragmento.dart';
import 'package:fretee_mobile/ui/home/fragmentos/fretes_agenda_fragmento.dart';
import 'package:fretee_mobile/ui/home/fragmentos/notificacao_fragmento.dart';
import 'package:fretee_mobile/ui/home/fragmentos/perfil_fragmento.dart';

class Home extends StatefulWidget {
  final Widget? activePage;
  final String? activePageTitle;
  const Home({Key? key, this.activePage, this.activePageTitle})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget _activePage;
  late String _activePageTitle;

  @override
  void initState() {
    super.initState();
    _activePage = widget.activePage ?? const BuscaPrestadoresServicoFragmento();
    _activePageTitle = widget.activePageTitle ?? "Buscar";

    //then()
    //gives you the menssagem on which user taps and opened the app from
    //terminated states
    FirebaseMessaging.instance.getInitialMessage();

    //Listen on foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        log(message.notification!.body.toString());
        log(message.notification!.title.toString());

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(message.notification!.title.toString()),
                  content: Text(message.notification!.body.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(
                                activePage: NotificacaoFragmento(),
                                activePageTitle: "Notificações",
                              ),
                            ),
                            (route) => false);
                      },
                      child: const Text('OK'),
                    )
                  ],
                ));
      }
    });

    //When the app is in background but opened and users taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(
              activePage: NotificacaoFragmento(),
              activePageTitle: "Notificações",
            ),
          ),
          (route) => false);
    });

    FirebaseMessaging.instance.getToken().then((value) {
      log("Atualizando firebase token");
      atualizarFirebaseToken(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_activePageTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _activePage,
      bottomNavigationBar: _getMenuNavegation(),
    );
  }

  Widget _getMenuNavegation() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(50)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        InkWell(
          onTap: () {
            setState(() {
              _activePage = const BuscaPrestadoresServicoFragmento();
              _activePageTitle = "Buscar";
            });
          },
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _activePage = const FretesAgendadosFragmento();
              _activePageTitle = "Fretes Agendados";
            });
          },
          child: const Icon(Icons.calendar_today, color: Colors.white),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _activePage = const NotificacaoFragmento();
              _activePageTitle = "Notificações";
            });
          },
          child: const Icon(Icons.notifications, color: Colors.white),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _activePage = const PerfilFragmento();
              _activePageTitle = "Perfil";
            });
          },
          child: const Icon(Icons.person_sharp, color: Colors.white),
        )
      ]),
    );
  }
}

Future<void> atualizarFirebaseToken(String? token) async {
  var response =
      await http.put(FreteeApi.getUriAtualizarFirebaseToken(), headers: {
    HttpHeaders.authorizationHeader: FreteeApi.getAccessToken(),
    HttpHeaders.contentTypeHeader: HttpMediaType.FORM_URLENCODED
  }, body: {
    "token": token
  });

  log(response.statusCode.toString());
}
