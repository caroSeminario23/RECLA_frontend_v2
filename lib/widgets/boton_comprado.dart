import 'package:flutter/material.dart';

class BotonComprado extends StatelessWidget {
  final VoidCallback? onPressed;

  const BotonComprado({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Ocupa el 90% del ancho de la pantalla
        padding: const EdgeInsets.symmetric(vertical: 15),
        //padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido horizontalmente
          mainAxisSize: MainAxisSize.max, 
          //mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer, size: 14, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 8),
            Text(
              'Venta concretada',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}