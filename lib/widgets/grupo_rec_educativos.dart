import 'package:flutter/material.dart';
import 'package:recla/widgets/portada_rec_eduactivos.dart';

class GrupoREducativos extends StatelessWidget {
  final List<Map<String, dynamic>> recursos;

  const GrupoREducativos({super.key, required this.recursos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate((recursos.length / 2).ceil(), (index) {
        final int first = index * 2;
        final int second = first + 1;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primer recurso educativo
              Expanded(child: PortadaREducativo(recurso: recursos[first])),

              const SizedBox(width: 8),

              // Segundo recurso educativo (si existe)
              Expanded(
                child:
                    second < recursos.length
                        ? PortadaREducativo(recurso: recursos[second])
                        : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }
}