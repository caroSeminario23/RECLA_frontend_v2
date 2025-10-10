import 'package:flutter/material.dart';

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
      1 => 'assets/images/racha.webp',
      2 => 'assets/images/ptos_compra.webp',
      3 => 'assets/images/ptos_venta.webp',
      4 => 'assets/images/ptos_rec_educativos.webp',
      _ => '',
    };

    final String formatoPuntaje = switch (tipoPuntaje) {
      1 => 'días',
      2 || 3 || 4 => 'num',
      _ => '',
    };

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centra el contenido horizontalmente
      children: [
        Image.asset(imgPuntaje, width: 30, height: 30),
        const SizedBox(width: 2), // Espacio entre la imagen y el texto
        Text(
          '$puntaje $formatoPuntaje',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}