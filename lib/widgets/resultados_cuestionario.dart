import 'package:flutter/material.dart';
import 'package:recla/screens/recursos_educativos.dart';

class ResultadosCuestionarioDialog extends StatelessWidget {
  final int respuestasCorrectas;
  final int totalPreguntas;
  final int puntosExperiencia;

  const ResultadosCuestionarioDialog({
    super.key,
    required this.respuestasCorrectas,
    required this.totalPreguntas,
    required this.puntosExperiencia,
  });

  @override
  Widget build(BuildContext context) {
    final porcentaje = (respuestasCorrectas / totalPreguntas * 100).toStringAsFixed(0);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título de felicitaciones
          Text(
            '¡FELICITACIONES!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Respuestas correctas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Respuestas correctas',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '$respuestasCorrectas/$totalPreguntas',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$porcentaje%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Puntos de experiencia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Puntos de experiencia obtenidos',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '+$puntosExperiencia XP',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botón "¡Genial!"
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RecursosEducativosPagina()),
                (route) => false,
              );
            },
            child: Text(
              '¡Genial!',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}