import 'package:flutter/material.dart';
import 'package:recla/widgets/tipo_puntaje.dart';

class BarraPuntos extends StatelessWidget {
  final int racha;
  final int ptosCompras;
  final int ptosVentas;
  final int ptosRecEducativos;

  const BarraPuntos({
    super.key,
    required this.racha,
    required this.ptosCompras,
    required this.ptosVentas,
    required this.ptosRecEducativos,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        TipoPuntaje(
          puntaje: racha, 
          tipoPuntaje: 1),
        
        const SizedBox(height: 9), // Espacio entre los tipos de puntaje
        
        TipoPuntaje(
          puntaje: ptosCompras, 
          tipoPuntaje: 2),
        
        const SizedBox(height: 9), // Espacio entre los tipos de puntaje

        TipoPuntaje(
          puntaje: ptosVentas, 
          tipoPuntaje: 3),

        const SizedBox(height: 9), // Espacio entre los tipos de puntaje
        
        TipoPuntaje(
          puntaje: ptosRecEducativos, 
          tipoPuntaje: 4)
      ],
    );
  }
}