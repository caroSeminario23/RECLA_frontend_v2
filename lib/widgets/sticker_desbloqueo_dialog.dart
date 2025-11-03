import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/utils/ref_imagenes.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/providers/stickers.dart';

class StickerDesbloqueoDialog extends StatelessWidget {
  //final String nombreInsignia;
  final int idSticker;
  final String urlImagen;
  //final String descripcion;
  final int monedasRequeridas;

  const StickerDesbloqueoDialog({
    super.key,
    //required this.nombreInsignia,
    required this.idSticker,
    required this.urlImagen,
    //required this.descripcion,
    required this.monedasRequeridas,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título
          Text(
            '¿CÓMO PUEDO\nCONSEGUIRLO?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          
          // Imagen y texto
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(urlImagen),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lo obtendrás cuando\nhayas alcanzado:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$monedasRequeridas monedas ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(monedas, width: 10, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          

          InkWell(
            onTap: () async {
              final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
              final stickerProvider = Provider.of<StickerProvider>(context, listen: false);

              final int idUsuario = usuarioProvider.idUsuario ?? 1;

              try {
                final resultado = await stickerProvider.desbloquearSticker(idUsuario, idSticker);

                if (!context.mounted) return;

                if (resultado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '¡Has desbloqueado un nuevo sticker!',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  if (!context.mounted) return;

                  await stickerProvider.obtenerStickers(idUsuario, 1); //emociones
                  await stickerProvider.obtenerStickers(idUsuario, 2); //reacciones
                  await stickerProvider.obtenerStickers(idUsuario, 3); //actividades

                  if (!context.mounted) return;
                  Navigator.of(context).pop(); // Cerrar el diálogo
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No has alcanzado las monedas necesarias para este sticker',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.onError,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                // Manejo de errores
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Ocurrió un error al intentar desbloquear el sticker',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },

            // Mensaje motivacional
            child: Text(
              '¡Lo he logrado!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.end,
              selectionColor: Theme.of(context).colorScheme.primary,
            ),

          )
          
        ],
      ),
    );
  }
}