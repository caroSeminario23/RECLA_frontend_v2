import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BotonesTipoMaterial extends StatelessWidget {
  final int plastico;
  final int carton;
  final int metal;
  final int vidrio;
  final void Function(String) onSelect;
  const BotonesTipoMaterial({
    super.key,
    required this.plastico,
    required this.carton,
    required this.metal,
    required this.vidrio,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Permite el desplazamiento horizontal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (plastico == 1)
            ElevatedButton.icon(
              onPressed: () {
                onSelect('1');
                // Acción para el botón de Plástico
              },
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(
                    context,
                  ).colorScheme.primary, // Color del ícono desde el Theme
                  BlendMode.srcIn, // Modo de mezcla para aplicar el color
                ),
                child: Image.asset(
                  'assets/images/logo-principal.png',
                  //'assets/images/icons/boton_plastico.png',
                  width: 24, // Ajusta el tamaño del ícono si es necesario
                  height: 24, // Ajusta el tamaño del ícono si es necesario
                ),
              ),
              label: Text(
                'Plástico',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
              ),
            ),
          const SizedBox(width:8),  // Espacio entre los botones
          // Añade un espacio entre los botones para que no se vean tan pegados
          if (carton == 1)
            ElevatedButton.icon(
              onPressed: () {
                onSelect('2');
                // Acción para el botón de Cartón
              },
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(
                    context,
                  ).colorScheme.primary, // Color del ícono desde el Theme
                  BlendMode.srcIn, // Modo de mezcla para aplicar el color
                ),
                child: Image.asset(
                  'assets/images/logo-principal.png',
                  //'assets/images/icons/boton_carton.png',
                  width: 24, // Ajusta el tamaño del ícono si es necesario
                  height: 24, // Ajusta el tamaño del ícono si es necesario
                ),
              ),
              label: Text(
                'Cartón',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
              ),
            ),
          const SizedBox(width:8),  // Espacio entre los botones
          if (metal == 1)
            ElevatedButton.icon(
              onPressed: () {
                onSelect('3');
                // Acción para el botón de Metal
              },
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(
                    context,
                  ).colorScheme.primary, // Color del ícono desde el Theme
                  BlendMode.srcIn, // Modo de mezcla para aplicar el color
                ),
                child: Image.asset(
                  'assets/images/logo-principal.png',
                  //'assets/images/icons/boton_metal.png',
                  width: 24, // Ajusta el tamaño del ícono si es necesario
                  height: 24, // Ajusta el tamaño del ícono si es necesario
                ),
              ),
              label: Text(
                'Metal',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
              ),
            ),
          const SizedBox(width:8),
          if (vidrio == 1)
            ElevatedButton.icon(
              onPressed: () {
                onSelect('4');
                // Acción para el botón de Vidrio
              },
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(
                    context,
                  ).colorScheme.primary, // Color del ícono desde el Theme
                  BlendMode.srcIn, // Modo de mezcla para aplicar el color
                ),
                child: Image.asset(
                  'assets/images/logo-principal.png',
                  //'assets/images/icons/boton_vidrio.png',
                  width: 24, // Ajusta el tamaño del ícono si es necesario
                  height: 24, // Ajusta el tamaño del ícono si es necesario
                ),
              ),
              label: Text(
                'Vidrio',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                ),
              ),
            ),
        ],
      ),
    );
  }
}