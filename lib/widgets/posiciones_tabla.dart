import 'package:flutter/material.dart';
import 'package:recla/widgets/posicion_tabla.dart';


class PosicionesTabla extends StatelessWidget {
  final List<Map<String, dynamic>> posiciones;
  final Function(int)? onItemTapped;

  const PosicionesTabla({super.key, required this.posiciones, this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          // MOSTRAR LOS 8 PUESTOS DE LA TABLA
          posiciones.map((posicion) {
            return GestureDetector(
              onTap: () {
                if (onItemTapped != null) {
                  onItemTapped!(posicion['idUsuario']);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: PosicionTabla(
                  imgAprendiz: posicion['imgAprendiz'],
                  idUsuario: posicion['idUsuario'],
                  nombreAprendiz: posicion['nombreAprendiz'],
                  expAprendiz: posicion['expAprendiz'],
                  puestoAprendiz: posicion['puestoAprendiz'],
                  seleccionado: posicion['seleccionado'],
                ),
              ),
            );
          }).toList(),
    );
  }
}