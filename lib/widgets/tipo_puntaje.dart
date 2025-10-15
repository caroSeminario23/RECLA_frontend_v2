import 'package:flutter/material.dart';
import 'package:recla/utils/ref_imagenes.dart';

class TipoPuntaje extends StatelessWidget {
  final int puntaje;
  final int tipoPuntaje;

  const TipoPuntaje({
    super.key,
    required this.puntaje,
    required this.tipoPuntaje,
  });

  @override
  Widget build(BuildContext context) {
    final String imgPuntaje = switch (tipoPuntaje) {
      1 => racha,
      2 => ptosCompra,
      3 => ptosVenta,
      4 => ptosRecEducativos,
      _ => '',
    };

    final String formatoPuntaje = switch (tipoPuntaje) {
      1 => (puntaje == 1) ? 'día' : 'días',
      2 || 3 || 4 => (puntaje == 1) ? 'ud' : 'uds',
      _ => '',
    };

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centra el contenido horizontalmente
      children: [
        Image.asset(imgPuntaje, width: 30, height: 30),
        const SizedBox(width: 1), // Espacio entre la imagen y el texto
        Text(
          '$puntaje $formatoPuntaje',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}