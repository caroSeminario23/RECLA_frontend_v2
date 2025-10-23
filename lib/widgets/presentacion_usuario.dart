import 'package:flutter/material.dart';

class PresentacionUsuario extends StatelessWidget {
  final String fotoAprendiz;
  final int experiencia;
  final String nombre;

  const PresentacionUsuario({
    super.key,
    required this.fotoAprendiz,
    required this.experiencia,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Para permitir que sobresalga
          children: [
            // Foto de usuario
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(fotoAprendiz),
                backgroundColor: Colors.transparent,
              ),
            ),

            // Botón de experiencia (ligeramente debajo de la imagen)
            Positioned(
              bottom: -12, // valor negativo para que sobresalga
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$experiencia EXP',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20), // espacio ajustado por el botón flotante
        // Nombre debajo
        Text(nombre, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}