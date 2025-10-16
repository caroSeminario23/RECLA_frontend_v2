import 'package:flutter/material.dart';
import 'package:recla/models/sticker.dart';
import 'package:recla/widgets/item_sticker.dart';

class GrupoStickers extends StatelessWidget {
  final List<StickersConEstado> stickers;

  const GrupoStickers({super.key, required this.stickers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate((stickers.length / 4).ceil(), (index) {
        final int first = index * 4;
        final int second = first + 1;
        final int third = first + 2;
        final int fourth = first + 3;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primer certificado
              Expanded(child: ItemSticker(sticker: stickers[first])),

              const SizedBox(width: 1),

              // Segundo certificado (si existe)
              Expanded(
                child:
                    second < stickers.length
                        ? ItemSticker(sticker: stickers[second])
                        : const SizedBox(),
              ),

              const SizedBox(width: 1),

              // Tercer certificado (si existe)
              Expanded(
                child:
                    third < stickers.length
                        ? ItemSticker(sticker: stickers[third])
                        : const SizedBox(),
              ),

              const SizedBox(width: 1),

              // Cuarto certificado (si existe)
              Expanded(
                child:
                    fourth < stickers.length
                        ? ItemSticker(sticker: stickers[fourth])
                        : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }
}