import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int opcionSeleccionada;
  final Function(int) onItemTapped;

  const NavBar({
    super.key,
    required this.opcionSeleccionada,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final iconPaths = [
      'assets/images/icons/ventas.png',
      'assets/images/icons/beneficios.png',
      'assets/images/icons/clasificacion.png',
      'assets/images/icons/chats.png',
      'assets/images/icons/perfil.png',
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(iconPaths.length, (index) {
          return _buildNavItem(iconPaths[index], index);
        }),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    final bool isSelected = index == opcionSeleccionada;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.4, // resaltado con opacidad
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            assetPath,
            width: isSelected ? 50 : 35,
            height: isSelected ? 50 : 35,
          ),
        ),
      ),
    );
  }
}
