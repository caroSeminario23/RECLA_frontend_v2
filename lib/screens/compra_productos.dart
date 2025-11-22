import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/login.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:recla/widgets/tarjeta_compra_producto.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/screens/registro_producto.dart';

class CompraProductosPagina extends StatefulWidget {
  const CompraProductosPagina({super.key});

  @override
  State<CompraProductosPagina> createState() => _CompraProductosState();
}

class _CompraProductosState extends State<CompraProductosPagina> {
  int opcionSeleccionada = 0; // Compra es la opción 0

  final List<int> _tipoSeleccionado = []; // Solo uno
  final List<int> _materialesSeleccionados = []; // Pueden ser varios
  List<ProductoFiltradoResponse> _productos = [];

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()));
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }
  
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
    developer.log('Buscar productos con tipo: $_tipoSeleccionado y materiales: $_materialesSeleccionados');
    if (_tipoSeleccionado.isEmpty || _materialesSeleccionados.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona tipo y material")),
      );
      return;
    }

    final materialString = _materialesSeleccionados.join(",");
    developer.log('Materiales seleccionados como string: $materialString');

    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    final productos = await Provider.of<ProductoProvider>(
      context,
      listen: false,
    ).filtrarP(_tipoSeleccionado, materialString, idUsuario);
    developer.log('Productos filtrados: $productos');
    developer.log('Productos filtrados: ${productos.length} items');
    
    if (!mounted) return;

    setState(() {
      _productos = productos;
    });
    developer.log('Productos encontrados: $_productos');
    developer.log('Productos encontrados: ${_productos.length}');
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
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const Login()));
          },
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
                      maxCrossAxisExtent: maxCrossAxisExtent,
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
                        opcion: 1
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

      bottomNavigationBar: SafeArea(
        top: false,
        child: NavBar(
          opcionSeleccionada: opcionSeleccionada,
          onItemTapped: _onItemTapped,
        ),
      ),

    );
  }
}