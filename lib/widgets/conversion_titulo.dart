// lib/widgets/conversacion_tile.dart
import 'package:flutter/material.dart';

class ConversacionTitulo extends StatelessWidget {
  final String nombre;
  final String ultimoMensaje;
  final String hora;
  final String? avatarUrl;
  final VoidCallback onTap;

  const ConversacionTitulo({
    super.key,
    required this.nombre,
    required this.ultimoMensaje,
    required this.hora,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[200], // Color de fondo por si falla la imagen
        backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
            ? NetworkImage(avatarUrl!)
            : null,
        child: (avatarUrl == null || avatarUrl!.isEmpty)
            ? Text(
                nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary
                ),
              ) // Inicial
            : null,
      ),
      title: Text(
        nombre,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        ultimoMensaje,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        hora,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}