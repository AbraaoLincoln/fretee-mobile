import 'package:flutter/material.dart';

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
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "imagens/user_female.png",
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
                    usuarioInfo["reputacaoUsuario"].toString(),
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
