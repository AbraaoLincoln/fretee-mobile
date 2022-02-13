import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';

class UsuarioInfo extends StatelessWidget {
  final Map<String, dynamic> usuarioInfo;
  const UsuarioInfo({Key? key, required this.usuarioInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _construirUsuarioInfo();
  }

  Widget _construirUsuarioInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                FreteeApi.getUriPrestadoresServicoFoto(
                    usuarioInfo["nomeUsuario"]),
                headers: {
                  HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
                },
                fit: BoxFit.cover,
                errorBuilder: (context, object, stackTrace) =>
                    const Text("Erro ao recuperar a imagem do usuario"),
              )),
        ),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              usuarioInfo["nomeUsuario"],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(children: [
                Row(children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(
                    usuarioInfo["reputacao"].toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  )
                ]),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red.shade700,
                    ),
                    Text("${usuarioInfo["distancia"]} km",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ]),
                )
              ]),
            )
          ]),
        ))
      ]),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    );
  }
}
