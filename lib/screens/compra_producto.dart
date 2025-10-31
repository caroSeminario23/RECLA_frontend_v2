// lib/screens/compra_productos.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:recla/widgets/tarjeta_compra_producto.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/screens/registro_producto.dart';
import 'package:recla/screens/chat.dart';

// --- AÑADE LA IMPORTACIÓN DE TU PANTALLA DE DETALLE ---
// (Asumo que tienes una pantalla de detalle, ej: 'detalle_producto_screen.dart')
// import 'package:recla/screens/detalle_producto_screen.dart';


class CompraProductos extends StatefulWidget {
  const CompraProductos({super.key});

  @override
  State<CompraProductos> createState() => _CompraProductosState();
}

class _CompraProductosState extends State<CompraProductos> {
  List<int> _tipoSeleccionado = [];
  List<int> _materialesSeleccionados = [];
  // --- USA EL ESTADO DEL PROVIDER EN LUGAR DE UN ESTADO LOCAL ---
  // List<ProductoFiltradoResponse> _productos = []; // <-- REEMPLAZADO

  // --- OBTENER EL ID ACTUAL (Debería venir de un AuthProvider) ---
  final int _idUsuarioActual = 2;

  void _onTipoSelected(int tipo) {
    setState(() {
      if (_tipoSeleccionado.contains(tipo)) {
        _tipoSeleccionado.remove(tipo);
      } else {
        _tipoSeleccionado.add(tipo);
      }
    });
  }

  void _onMaterialSelected(String materialId) {
    final id = int.parse(materialId);
    setState(() {
      if (_materialesSeleccionados.contains(id)) {
        _materialesSeleccionados.remove(id);
      } else {
        _materialesSeleccionados.add(id);
      }
    });
  }

  Future<void> _buscarProductos() async {
    print('Buscar productos con tipo: $_tipoSeleccionado y materiales: $_materialesSeleccionados');
    if (_tipoSeleccionado.isEmpty || _materialesSeleccionados.isEmpty) { // <-- Corregí la validación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona tipo y material")),
      );
      return;
    }

    final materialString = _materialesSeleccionados.map((id) => id.toString()).join(","); // <-- Corregí el join
    print('Materiales seleccionados como string: $materialString');
    
    // El provider ya guarda la lista, no necesitamos un estado local 'productos'
    await Provider.of<ProductoProvider>(
      context,
      listen: false,
    ).filtrarP(_tipoSeleccionado, materialString);
    
    // setState(() {
    //   _productos = productos; // <-- YA NO ES NECESARIO
    // });
  }

  @override
  Widget build(BuildContext context) {
    // --- ACCEDE A LOS PRODUCTOS DESDE EL PROVIDER ---
    final productoProvider = Provider.of<ProductoProvider>(context);
    final productos = productoProvider.productosFiltrados; // <-- Lee la lista del provider

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'COMPRA DE PRODUCTOS',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_outlined, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // --- OJO AQUÍ ---
                  // Esto es solo para probar la navegación al chat
                  // Tu pantalla de Chat AHORA REQUIERE idUsuarioReceptor
                  // Tu código original fallaría.
                  builder: (_) => Chat(
                    idUsuarioActual: _idUsuarioActual, // Tú
                    idUsuarioReceptor: 1, // ID de prueba para 'Flor Campestre'
                    nombreUsuario: 'Flor Campestre',
                  ),
                  // Lo correcto aquí probablemente es:
                  // builder: (context) => const RegistroProducto(),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ... (LayoutBuilder se mantiene igual) ...
          return SingleChildScrollView(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ... (BotonesTipoMaterial y BotonesTipo se mantienen igual) ...
                BotonesTipoMaterial(
                  plastico: 1,
                  carton: 1,
                  metal: 1,
                  vidrio: 1,
                  onSelect: _onMaterialSelected,
                ),
                const SizedBox(height: 8),
                BotonesTipo(
                  material: 1,
                  producto: 1,
                  onSelect: _onTipoSelected,
                ),
                const SizedBox(height: 8),
                // ... (Botón de búsqueda se mantiene igual) ...
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _buscarProductos,
                    icon: const Icon(Icons.search),
                    label: const Text("Buscar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                // --- MUESTRA LOADING O RESULTADOS ---
                if (productoProvider.isLoading == true)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (productos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No hay productos para mostrar"),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          constraints.maxWidth /
                              (constraints.maxWidth > 600 ? 3 : 2),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      // --- AÑADE INKWELL PARA NAVEGACIÓN ---
                      return InkWell(
                        onTap: () {
                          // --- ESTA ES LA NAVEGACIÓN CORRECTA ---
                          // Aquí navegas a tu pantalla de detalle,
                          // pasando el ID del producto.
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProductoScreen(
                                idProducto: producto.idProducto,
                              ),
                            ),
                          );
                          */
                          
                          // Muestra un print por ahora:
                          print('Navegar al detalle del producto ${producto.idProducto}');
                        },
                        child: TarjetaCompraProductos(
                          fotoProducto: producto.urlFoto,
                          nombreProducto: producto.nombre,
                          tipo: producto.tipo,
                          precio: producto.precio.toInt(),
                          idProducto: producto.idProducto,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}