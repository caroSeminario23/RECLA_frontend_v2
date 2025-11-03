// lib/widgets/detalle_y_comprar_producto.dart (o donde lo tengas)

import 'package:flutter/material.dart';
import 'package:recla/screens/chat.dart';
// Asumo que tienes un provider de autenticación para el ID actual
// import 'package:provider/provider.dart'; 
// import 'package:recla/providers/auth_provider.dart';

class DetalleYComprarProducto extends StatelessWidget {
  final int idProducto;
  final String descripcion;
  // --- AÑADIDOS ---
  final int idVendedor;
  final String nombreVendedor;
  // final VoidCallback onPressed; // Este parámetro no se usaba en tu código

  const DetalleYComprarProducto({
    super.key,
    required this.idProducto,
    required this.descripcion,
    required this.idVendedor,      // <-- AÑADIDO
    required this.nombreVendedor,  // <-- AÑADIDO
    // required this.onPressed, // <-- Lo quito porque tu botón ya tenía su propia lógica
  });

  @override
  Widget build(BuildContext context) {
    // --- OBTENER ID DE USUARIO ACTUAL ---
    // En lugar de '2', deberías obtener el ID del usuario logueado.
    // Por ejemplo, desde un AuthProvider:
    // final idUsuarioActual = Provider.of<AuthProvider>(context).usuario.id;
    // Por ahora, lo dejaré hardcodeado como '2'
    const int idUsuarioActual = 6;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ... (El resto de tu widget se mantiene igual) ...
          Text(
            'DETALLES DEL PRODUCTO',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // --- BOTÓN "Comprar producto" MODIFICADO ---
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton.icon(
              onPressed: () {
                // --- LÓGICA DE NAVEGACIÓN CORREGIDA ---
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Chat( // <-- Ya no es 'const'
                      idUsuarioActual: idUsuarioActual, // El comprador (tú)
                      idUsuarioReceptor: idVendedor,    // El vendedor (del producto)
                      nombreUsuario: nombreVendedor, // El nombre del vendedor
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
              label: Text(
                'Comprar producto',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                ),
              ),
              // ... (El resto de tu estilo de botón se mantiene igual) ...
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}