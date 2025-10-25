import 'package:flutter/material.dart';
import 'package:recla/utils/ref_imagenes.dart';

class InsigniaDesbloqueoDialog extends StatelessWidget {
  //final String nombreInsignia;
  final int idInsignia;
  final String urlImagen;
  //final String descripcion;
  final int comprasRequeridas;

  const InsigniaDesbloqueoDialog({
    super.key,
    //required this.nombreInsignia,
    required this.idInsignia,
    required this.urlImagen,
    //required this.descripcion,
    required this.comprasRequeridas,
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
            '¿CÓMO PUEDO\nCONSEGUIRLA?',
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
                radius: 50,
                backgroundImage: NetworkImage(urlImagen),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'La obtendrás cuando\nhayas realizado:',
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
                            '$comprasRequeridas compras ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(ptosCompra, width: 30, height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Mensaje motivacional
          Text(
            '¡Lo he logrado!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.end,
            selectionColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}