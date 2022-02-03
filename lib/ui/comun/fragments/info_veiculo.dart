import 'dart:io';
import 'package:fretee_mobile/business/veiculo_info.dart';
import 'package:flutter/material.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';

class InfoVeiculo extends StatelessWidget {
  final String nomeUsuarioPrestadorServico;
  final VeiculoInfo veiculo;
  const InfoVeiculo(
      {Key? key,
      required this.nomeUsuarioPrestadorServico,
      required this.veiculo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _construirVeiculoInfo();
  }

  Widget _construirVeiculoInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _construirImagemDoVeiculo(),
          _construirInfoDimensoesVeiculo()
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          border: Border.all(color: Colors.grey.shade400)),
    );
  }

  Widget _construirImagemDoVeiculo() {
    return Expanded(
        child: FittedBox(
      child: Image.network(
          FreteeApi.getUriPrestadoresServicoFotoVeiculo(
              nomeUsuarioPrestadorServico),
          headers: {
            HttpHeaders.authorizationHeader: FreteeApi.getAccessToken()
          },
          errorBuilder: (context, object, stackTrace) =>
              const Text("Erro ao recuperar a imagem do veiculo")),
      fit: BoxFit.fill,
    ));
  }

  Widget _construirInfoDimensoesVeiculo() {
    if (veiculo.hasErros) {
      return const Center(
        child: Text("Nao foi possivel recuperar os dados do veiculo"),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _construirTextInfoVeiculo(
                "Comprimento", veiculo.info["comprimento"].toString()),
            _construirTextInfoVeiculo(
                "Altura", veiculo.info["altura"].toString()),
            _construirTextInfoVeiculo(
                "Largura", veiculo.info["largura"].toString())
          ],
        ),
      );
    }
  }

  Widget _construirTextInfoVeiculo(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          "$valor mm",
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
