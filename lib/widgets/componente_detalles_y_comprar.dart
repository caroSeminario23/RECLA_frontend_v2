import 'package:flutter/material.dart';

class DetalleYComprarProducto extends StatelessWidget {
  final int idProducto; // ID del producto
  final String descripcion;
  final VoidCallback onPressed;

  const DetalleYComprarProducto({
    super.key,
    required this.idProducto,
    required this.onPressed,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    // Buscar el detalle del producto por ID
    /*final productoDetalle = datosDetalleProductos.firstWhere(
      (producto) => producto['id_producto'] == idProducto,
      orElse: () => {'detalle': 'Detalle no encontrado'}, // Manejo de error si no se encuentra el ID
    );*/

    //final detalle = "detalle";//productoDetalle['detalle']; // Extraer el campo detalle

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Margen horizontal
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título: "DETALLES DEL PRODUCTO"
          Text(
            'DETALLES DEL PRODUCTO',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8), // Espacio entre el título y el detalle

          // Detalle del producto
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16), // Espacio entre el detalle y el botón

          // Botón "Comprar producto"
          SizedBox(
            width: MediaQuery.of(context).size.width, // Ocupa todo el ancho de la pantalla
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: MediaQuery.of(context).size.width * 0.06, // Tamaño del ícono proporcional
              ),
              label: Text(
                'Comprar producto',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045, // Tamaño del texto proporcional
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // Color de fondo del botón
                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer, // Color del texto y del ícono
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Bordes redondeados
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant, // Color del borde
                    width: 1, // Grosor del borde
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.03, // Espaciado vertical proporcional
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Espacio entre el botón y el final del widget
        ],
      ),
    );
  }
}