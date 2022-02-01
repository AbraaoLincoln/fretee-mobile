import 'package:flutter/material.dart';
import 'package:fretee_mobile/utils/placeholders.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/mensagem.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/servico_info.dart';
import 'package:fretee_mobile/ui/solicitacao_frete/fragments/usuario_info.dart';
import 'package:http/http.dart' as http;

class SolicitarServicoAvaliacaoPreco extends StatelessWidget {
  final int freteId;
  final String nomeUsuarioPresadorServico;
  const SolicitarServicoAvaliacaoPreco(
      {Key? key,
      required this.freteId,
      required this.nomeUsuarioPresadorServico})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avaliar Preço Serviço"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [_getMensagem(), _construirFreteInfo(), _construirBotoes()],
        ),
      ),
    );
  }

  Widget _getMensagem() {
    return MensagemSolicitacaoServico(nomeUsuario: nomeUsuarioPresadorServico);
  }

  Widget _construirFreteInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
      child: Column(
        children: [
          UsuarioInfo(usuarioInfo: PlaceholderUtils.getUsuario()),
          ServicoInfo(freteInfo: PlaceholderUtils.getFrete())
        ],
      ),
    );
  }

  Widget _construirBotoes() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 55,
          child: TextButton(
              onPressed: () {},
              child:
                  const Text("Aceitar Preço", style: TextStyle(fontSize: 20)),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(400, 10))),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 55,
          child: TextButton(
              onPressed: () {},
              child:
                  const Text("Recusar Preço", style: TextStyle(fontSize: 20)),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(400, 10))),
        )
      ],
    );
  }
}

// class SolicitarServicoPreco extends StatefulWidget {
//   const SolicitarServicoPreco({Key? key}) : super(key: key);

//   @override
//   _SolicitarServicoPrecoState createState() => _SolicitarServicoPrecoState();
// }

// class _SolicitarServicoPrecoState extends State<SolicitarServicoPreco> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Solicitar Serviço"),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [_getMensagem(), _construirFreteInfo(), _construirBotoes()],
//         ),
//       ),
//     );
//   }

//   Widget _getMensagem() {
//     String nomeUsuario = "Fulano";
//     return MensagemSolicitacaoServico(nomeUsuario: nomeUsuario);
//   }

//   Widget _construirFreteInfo() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 1,
//               offset: const Offset(0, 1), // changes position of shadow
//             ),
//           ]),
//       child: Column(
//         children: [
//           UsuarioInfo(usuarioInfo: PlaceholderUtils.getUsuario()),
//           ServicoInfo(freteInfo: PlaceholderUtils.getFrete())
//         ],
//       ),
//     );
//   }

//   Widget _construirBotoes() {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.only(top: 20),
//           height: 55,
//           child: TextButton(
//               onPressed: () {},
//               child:
//                   const Text("Aceitar Preço", style: TextStyle(fontSize: 20)),
//               style: TextButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   primary: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   minimumSize: const Size(400, 10))),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 20),
//           height: 55,
//           child: TextButton(
//               onPressed: () {},
//               child:
//                   const Text("Recusar Preço", style: TextStyle(fontSize: 20)),
//               style: TextButton.styleFrom(
//                   backgroundColor: Colors.red.shade900,
//                   primary: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   minimumSize: const Size(400, 10))),
//         )
//       ],
//     );
//   }
// }
