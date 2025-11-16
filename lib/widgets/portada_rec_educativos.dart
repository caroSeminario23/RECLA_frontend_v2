import 'package:flutter/material.dart';
import 'package:recla/models/recurso_educativo.dart';
import 'package:recla/screens/rec_edu_contenido.dart';

class PortadaREducativo extends StatelessWidget {
  final RecursoEducativoPortada recurso;

  const PortadaREducativo({
    super.key,
    required this.recurso,
  });

  @override
  Widget build(BuildContext context) {
    final String nombreTipoRecurso = switch (recurso.tipoContenido) {
      1 => 'Art. web',
      2 => 'Infografía',
      3 => 'Video',
      4 => 'Art. cient.',
      _ => '',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => RecEduContenidoPagina(recursoPortada: recurso)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          minimumSize: const Size.fromHeight(270),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // IMAGEN
                Image.network(recurso.portadaUrl, width: 155, height: 155),

                // BOTÓN SOBREPUESTO
                Positioned(
                  bottom: -18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFBCCEC1), 
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      nombreTipoRecurso,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24), // deja espacio para la superposición

            // TÍTULO DEL RECURSO
            Text(
              recurso.titulo,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),

            const SizedBox(height: 3),

            // PORCENTAJE DE ACIERTO Y ESTADO DEL RECURSO
            Text(
              '${_obtenerEstadoRecurso(recurso)} ${recurso.porcentajeAcierto}%',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para calcular el estado
  String _obtenerEstadoRecurso(RecursoEducativoPortada recurso) {
    if (!recurso.resuelto) return '⚫';
    
    if (recurso.porcentajeAcierto == 0) return '🔴';
    if (recurso.porcentajeAcierto < 100) return '🟡';
    return '🟢';
  }
}