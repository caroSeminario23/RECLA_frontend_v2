import 'package:flutter/material.dart';

class BotonPrecio extends StatelessWidget {
  final String precio;

  const BotonPrecio({super.key, required this.precio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant, // Color del borde
          width: 2, // Ancho del borde
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Precio: ',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 1), // Espacio entre el texto y el icono
          Text(
            precio,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 1), // Espacio entre el precio y el icono
          Image.asset(
            'assets/images/icons/boton_plastico.png',
            //'assets/images/icons/precio.png',
            width: 20, // Ajusta el tamaño del icono si es necesario
            height: 20, // Ajusta el tamaño del icono si es necesario
          ), // Espacio entre el icono y el texto
        ],
      ),
    );
  }
}
