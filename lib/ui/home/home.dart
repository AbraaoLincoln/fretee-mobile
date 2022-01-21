import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fretee_mobile/ui/home/fragmentos/buscar_fragmento.dart';
import 'package:fretee_mobile/ui/home/fragmentos/fretes_agenda_fragmento.dart';
import 'package:fretee_mobile/ui/home/fragmentos/notificacao_fragmento.dart';
import 'package:fretee_mobile/ui/home/fragmentos/perfil_fragmento.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _activePage = const BuscaPrestadoresServicoFragmento();
  String _activePageTitle = "Buscar";

  @override
  void initState() {
    super.initState();

    //then()
    //gives you the menssagem on which user taps and opened the app from
    //terminated states
    FirebaseMessaging.instance.getInitialMessage();

    //Listen on foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        log(message.notification!.body.toString());
        log(message.notification!.title.toString());

        setState(() {
          _activePage = const NotificacaoFragmento();
          _activePageTitle = "Notificações";
        });
      }
    });

    //When the app is in background but opened and users taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
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
