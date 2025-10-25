import 'package:flutter/material.dart';
import 'package:recla/models/sticker.dart';
import 'package:recla/utils/ref_imagenes.dart';
import 'package:recla/widgets/sticker_desbloqueo_dialog.dart';

class ItemSticker extends StatelessWidget {
  final StickersConEstado sticker;

  const ItemSticker({
    super.key,
    required this.sticker,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !sticker.desbloqueado
          ? () {
              showDialog(
                context: context,
                builder: (context) => StickerDesbloqueoDialog(
                  idSticker: sticker.idSticker,
                  urlImagen: sticker.urlImagen,
                  monedasRequeridas: sticker.precio,
                ),
              );
            }
          : null,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none, // Para permitir que sobresalga
            children: [
              // IMAGEN DEL STICKER
              Image.network(
                sticker.urlImagen, 
                width: 90, 
                height: 90,
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
                        color: Colors.black.withValues(alpha: 0.2),
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
                        monedas,
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
    /*
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
                      color: Colors.black.withValues(alpha: 0.2),
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
                      monedas,
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
  */


}