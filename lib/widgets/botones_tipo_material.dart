import 'package:flutter/material.dart';

class BotonesTipoMaterial extends StatefulWidget {
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
  State<BotonesTipoMaterial> createState() => _BotonesTipoMaterialState();
}

class _BotonesTipoMaterialState extends State<BotonesTipoMaterial> {
  int? _materialSeleccionado1; // Para plástico
  int? _materialSeleccionado2; // Para cartón  
  int? _materialSeleccionado3; // Para metal
  int? _materialSeleccionado4; // Para vidrio

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.plastico == 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_materialSeleccionado1 == 1) {
                    _materialSeleccionado1 = null; // Deseleccionar si ya está seleccionado
                  } else {
                    _materialSeleccionado1 = 1; // Seleccionar Plástico
                  }
                });
                widget.onSelect('1');
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
              label: Text('Plástico', style: Theme.of(context).textTheme.labelLarge),
              style: ElevatedButton.styleFrom(
                backgroundColor: _materialSeleccionado1 == 1
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.outlineVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          const SizedBox(width: 8),
          if (widget.carton == 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_materialSeleccionado2 == 1) {
                    _materialSeleccionado2 = null; // Deseleccionar si ya está seleccionado
                  } else {
                    _materialSeleccionado2 = 1; // Seleccionar Cartón
                  }
                });
                widget.onSelect('2');
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
              label: Text('Cartón', style: Theme.of(context).textTheme.labelLarge),
              style: ElevatedButton.styleFrom(
                backgroundColor: _materialSeleccionado2 == 1
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.outlineVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          const SizedBox(width: 8),
          if (widget.metal == 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_materialSeleccionado3 == 1) {
                    _materialSeleccionado3 = null; // Deseleccionar si ya está seleccionado
                  } else {
                    _materialSeleccionado3 = 1; // Seleccionar Metal
                  }
                });
                widget.onSelect('3');
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
              label: Text('Metal', style: Theme.of(context).textTheme.labelLarge),
              style: ElevatedButton.styleFrom(
                backgroundColor: _materialSeleccionado3 == 1
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.outlineVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          const SizedBox(width: 8),
          if (widget.vidrio == 1)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_materialSeleccionado4 == 1) {
                    _materialSeleccionado4 = null; // Deseleccionar si ya está seleccionado
                  } else {
                    _materialSeleccionado4 = 1; // Seleccionar Vidrio
                  }
                });
                widget.onSelect('4');
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
              label: Text('Vidrio', style: Theme.of(context).textTheme.labelLarge),
              style: ElevatedButton.styleFrom(
                backgroundColor: _materialSeleccionado4 == 1
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.outlineVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
/*/import 'package:flutter/gestures.dart';
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
                    Theme.of(context).colorScheme.outlineVariant,
                    //Theme.of(context).colorScheme.secondaryContainer,
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
}*/