import 'package:flutter/material.dart';

class Estrela extends StatelessWidget {
  final int? id;
  final EstadoEstrela estadoEstrela;
  final void Function(int, EstadoEstrela)? onTapCallback;
  const Estrela(
      {Key? key, required this.estadoEstrela, this.id, this.onTapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTapCallback != null) onTapCallback!(id ?? 0, estadoEstrela);
      },
      child: _getStarIconFor(estadoEstrela),
    );
  }

  Widget _getStarIconFor(EstadoEstrela estadoEstrela) {
    const Color? color = Colors.amber;
    const double? size = 50;

    switch (estadoEstrela) {
      case EstadoEstrela.vazia:
        return const Icon(Icons.star_outline, color: color, size: size);
      case EstadoEstrela.meia:
        return const Icon(Icons.star_half, color: color, size: size);
      case EstadoEstrela.cheia:
        return const Icon(Icons.star, color: color, size: size);
    }
  }
}

enum EstadoEstrela { vazia, meia, cheia }
