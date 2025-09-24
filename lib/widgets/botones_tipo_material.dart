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
              icon: Icon(
                Icons.local_drink, // Icono de reciclaje para plástico
                color: _materialSeleccionado1 == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
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
              icon: Icon(
                Icons.view_in_ar,
                color: _materialSeleccionado2 == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
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
              icon: Icon(
                Icons.hardware,
                color: _materialSeleccionado3 == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
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
              icon: Icon(
                Icons.wine_bar,
                color: _materialSeleccionado4 == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
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
