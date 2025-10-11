import 'package:flutter/material.dart';

class PortadaREducativo extends StatelessWidget {
  final Map<String, dynamic> recurso;

  const PortadaREducativo({
    super.key,
    required this.recurso,
  });

  @override
  Widget build(BuildContext context) {
    final String nombreTipoRecurso = switch (recurso['tipoRecurso']) {
      1 => 'Video',
      2 => 'Infografía',
      3 => 'Artículo',
      _ => '',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidad en desarrollo')),
          );
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
                Image.network(recurso['imgPortada'], width: 155, height: 155),

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
                          color: Colors.black.withOpacity(0.1),
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
              recurso['titulo'],
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
}