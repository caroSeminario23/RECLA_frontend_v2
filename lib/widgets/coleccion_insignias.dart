import 'package:flutter/material.dart';
import 'package:recla/models/insignia.dart';
import 'package:recla/utils/ref_imagenes.dart';

class ColeccionInsignias extends StatelessWidget {
  final String nombreColeccion;
  final List<InsigniaConEstado> insignias;
  final int tipoContador;
  final int valorContador;

  const ColeccionInsignias({
    super.key,
    required this.nombreColeccion,
    required this.insignias,
    required this.tipoContador,
    required this.valorContador,
  });

  @override
  Widget build(BuildContext context) {
    final String imgContador = switch (tipoContador) {
      1 => ptosCompra,
      2 => ptosVenta,
      3 => ptosRecEducativos,
      _ => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SUBTÍTULO CENTRADO
            Text(
              nombreColeccion,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            // ESPACIO ENTRE EL TEXTO Y LA IMAGEN
            const SizedBox(width: 10), // Espacio entre el texto y la imagen
            
            // IMAGEN DEL CONTADOR
            Image.asset(imgContador, width: 30, height: 30),

            // ESPACIO ENTRE LA IMAGEN Y EL TEXTO
            const SizedBox(width: 1),

            // TEXTO DEL CONTADOR
            Text(
              '$valorContador',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.start,
            ),
          ],
        ),

        // LISTA HORIZONTAL DE INSIGNIAS
        SizedBox(
          height: 160,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ESPACIO ENTRE NIVEL Y INSIGNIAS
                const SizedBox(height: 4),

                // FILA DE INSIGNIAS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra horizontalmente
                  children: insignias.map((insignia) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: _buildInsignia(insignia, context),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsignia(InsigniaConEstado insignia, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          insignia.urlImagen,
          height: 90,
          width: 90,
          fit: BoxFit.contain,
          // Podemos agregar condición para mostrar desactivada si no está desbloqueada
          color: insignia.desbloqueada ? null : Colors.grey,
          colorBlendMode: insignia.desbloqueada ? BlendMode.srcIn : BlendMode.saturation,
        ),
        const SizedBox(height: 1),

        // TÍTULO DE LA INSIGNIA
        SizedBox(
          width: 90,
          child: Text(
            insignia.nombre,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: insignia.desbloqueada ? null : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true
          ),
        ),
      ],
    );
  }
}