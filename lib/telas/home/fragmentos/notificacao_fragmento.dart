import 'package:flutter/material.dart';

class NotificacaoFragmento extends StatefulWidget {
  const NotificacaoFragmento({Key? key}) : super(key: key);

  @override
  _NotificacaoFragmentoState createState() => _NotificacaoFragmentoState();
}

class _NotificacaoFragmentoState extends State<NotificacaoFragmento> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _construirNotificacao(
                "Solicitação De Serviço", Icons.email, Colors.black, () {
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CadastroUsuario()),
              // );
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
}
