import 'package:flutter/material.dart';

class DatosRecursoEducativo extends StatelessWidget {
  final int? tipoContenido;
  final bool? resuelto;
  final double porcentajeAcierto;
  final String? referencia;

  const DatosRecursoEducativo({
    super.key,
    required this.tipoContenido,
    required this.resuelto,
    required this.porcentajeAcierto,
    required this.referencia,
  });

  @override
  Widget build(BuildContext context) {
    final String nombreTipoRecurso = switch (tipoContenido) {
      1 => 'Art. web',
      2 => 'Infografía',
      3 => 'Video',
      4 => 'Art. cient.',
      _ => '',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          // FILA 1: Tipo contenido y referencia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Tipo contenido
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.stacked_bar_chart,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        nombreTipoRecurso,
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),

              // Referencia
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        referencia?.toString() ?? 'Sin referencia',
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // FILA 2: Estado y porcentaje de acierto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Estado
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.checklist_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        resuelto == true ? 'Resuelto' : 'No resuelto',
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),

              // Porcentaje de acierto
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.numbers,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$porcentajeAcierto %',
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}