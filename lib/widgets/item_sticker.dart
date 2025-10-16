import 'package:flutter/material.dart';
import 'package:recla/models/sticker.dart';

class ItemSticker extends StatelessWidget {
  final StickersConEstado sticker;

  const ItemSticker({
    super.key,
    required this.sticker,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Para permitir que sobresalga
          children: [
            // IMAGEN DEL STICKER
            Image.network(
              sticker.urlImagen, 
              width: 80, 
              height: 80,
              color: sticker.desbloqueado ? null : Colors.grey,
              colorBlendMode: sticker.desbloqueado ? BlendMode.srcIn : BlendMode.saturation,
            ),

            // PRECIO DEL STICKER (ligeramente debajo de la imagen)
            Positioned(
              bottom: -8, // valor negativo para que sobresalga
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
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TEXTO DEL PRECIO
                    Text(
                      '${sticker.precio}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),

                    // ESPACIO ENTRE TEXTO Y ICONO
                    const SizedBox(height: 1),

                    // ICONO DE LA APLICACION
                    Image.asset(
                      'assets/images/racha.webp',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}