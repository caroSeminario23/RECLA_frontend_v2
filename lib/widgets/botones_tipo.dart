import 'package:flutter/material.dart';


class BotonesTipo extends StatefulWidget {
  final int material;
  final int producto;
  final void Function(int) onSelect;

  const BotonesTipo({
    super.key,
    required this.material,
    required this.producto,
    required this.onSelect,
  });

  @override
  State<BotonesTipo> createState() => _BotonesTipoState();
}

class _BotonesTipoState extends State<BotonesTipo> {
  int? _tipoSeleccionado1; // null = ninguno seleccionado
  int? _tipoSeleccionado2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.material == 1)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                if (_tipoSeleccionado1 == 1) {
                  _tipoSeleccionado1 = null; // Deseleccionar si ya está seleccionado
                } else {
                  _tipoSeleccionado1 = 1; // Seleccionar Material
                }
              });
              widget.onSelect(1);
            },
            icon: Icon(
              Icons.construction_outlined, // Icono de reciclaje para plástico
              color: _tipoSeleccionado1 == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: Text('Material', style: Theme.of(context).textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              backgroundColor: _tipoSeleccionado1 == 1
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.outlineVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        if (widget.producto == 1)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                if (_tipoSeleccionado2 == 1) {
                  _tipoSeleccionado2 = null; // Deseleccionar si ya está seleccionado
                } else {
                  _tipoSeleccionado2 = 1; // Seleccionar Producto
                }
              });
              widget.onSelect(2);
            },
            icon: Icon(
              Icons.pan_tool_outlined, // Icono de reciclaje para plástico
              color: _tipoSeleccionado2 == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: Text('Producto', style: Theme.of(context).textTheme.labelLarge),
            style: ElevatedButton.styleFrom(
              backgroundColor: _tipoSeleccionado2 == 1
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.outlineVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
