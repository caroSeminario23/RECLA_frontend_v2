import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:recla/widgets/tarjeta_compra_producto.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/screens/registro_producto.dart';

class CompraProductos extends StatefulWidget {
  const CompraProductos({super.key});

  @override
  State<CompraProductos> createState() => _CompraProductosState();
}

class _CompraProductosState extends State<CompraProductos> {
  List<int> _tipoSeleccionado = []; // Solo uno
  List<int> _materialesSeleccionados = []; // Pueden ser varios
  List<ProductoFiltradoResponse> _productos = [];

  void _onTipoSelected(int tipo) {
    setState(() {
      if (_tipoSeleccionado.contains(tipo)) {
        _tipoSeleccionado.remove(tipo);
      }
      else{
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
    if (_tipoSeleccionado == null || _materialesSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona tipo y material")),
      );
      return;
    }

    final materialString = _materialesSeleccionados.join(",");
    print('Materiales seleccionados como string: $materialString');
    final productos = await Provider.of<ProductoProvider>(
      context,
      listen: false,
    ).filtrarP(_tipoSeleccionado, materialString);
    print('Productos filtrados: $productos');
    setState(() {
      _productos = productos;
    });
    print('Productos encontrados: ${_productos}');
  }

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => const RegistroProducto(),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine max item width
          final maxCrossAxisExtent =
              constraints.maxWidth / (constraints.maxWidth > 600 ? 3 : 2);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BotonesTipoMaterial(
                  plastico: 1, //datosTiposMaterial['plastico'] ?? 0,
                  carton: 1, //datosTiposMaterial['carton'] ?? 0,
                  metal: 1, //datosTiposMaterial['metal'] ?? 0,
                  vidrio: 1, //datosTiposMaterial['vidrio'] ?? 0,
                  onSelect: _onMaterialSelected,
                ),
                const SizedBox(height: 8),
                BotonesTipo(
                  material: 1, //datosTipoCompra['material'] ?? 0,
                  producto: 1, //datosTipoCompra['producto'] ?? 0,
                  onSelect: _onTipoSelected,
                ),
                const SizedBox(height: 8),
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
                if (_productos.isEmpty)
                  const Text("No hay productos para mostrar")
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
                    itemCount: _productos.length,
                    // En el itemBuilder del GridView
                    itemBuilder: (context, index) {
                      final producto = _productos[index];
                      return TarjetaCompraProductos(
                        fotoProducto: producto.urlFoto,
                        nombreProducto: producto.nombre,
                        tipo: producto.tipo,
                        precio: producto.precio.toInt(),
                        idProducto: producto.idProducto, // ← Agregar esta línea
                      );
                    },
                    /*itemBuilder: (context, index) {
                      final producto = _productos[index];
                      return InkWell(
                        child: TarjetaCompraProductos(
                          fotoProducto: producto.urlFoto,
                          nombreProducto: producto.nombre,
                          tipo: producto.tipo,
                          //tipo: _tipoSeleccionado.isNotEmpty ? _tipoSeleccionado.first : 0,
                          precio: producto.precio.toInt(),
                        ),
                      );
                    },*/
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
