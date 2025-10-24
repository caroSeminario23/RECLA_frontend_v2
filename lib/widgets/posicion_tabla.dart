import 'package:flutter/material.dart';
import 'package:recla/utils/ref_imagenes.dart';

class PosicionTabla extends StatelessWidget {
  final String imgAprendiz;
  final int idUsuario;
  final String nombreAprendiz;
  final int expAprendiz;
  final int puestoAprendiz;
  final bool seleccionado;

  const PosicionTabla({
    super.key,
    required this.imgAprendiz,
    required this.idUsuario,
    required this.nombreAprendiz,
    required this.expAprendiz,
    required this.puestoAprendiz,
    required this.seleccionado,
  });

  @override
  Widget build(BuildContext context) {
    final String puestoImagePath = switch (puestoAprendiz) {
      1 => puesto1,
      2 => puesto2,
      3 => puesto3,
      4 => puesto4,
      5 => puesto5,
      6 => puesto6,
      7 => puesto7,
      8 => puesto8,
      _ => '',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // FOTO DE PERFIL
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(imgAprendiz),
              backgroundColor: Colors.transparent,
            ),
          ),

          // ESPACIO ENTRE AVATAR Y TEXTO
          const SizedBox(width: 10),

          // NOMBRE Y EXPERIENCIA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreAprendiz,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        seleccionado
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$expAprendiz EXP',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        seleccionado
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                // DIVISIÓN
                Divider(
                  thickness: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
          // PUESTO
          Image.asset(puestoImagePath, width: 65, height: 65),

          //const SizedBox(height: 5),
        ],
      ),
    );
  }
}