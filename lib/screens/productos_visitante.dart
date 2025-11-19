import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/producto.dart';
//import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/perfil_visitante.dart';
//import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/tarjeta_compra_producto.dart';
import 'package:recla/widgets/navbar.dart';

class ProductosVisitantePagina extends StatefulWidget {
  final int idUsuarioVisitante;

  const ProductosVisitantePagina({super.key, required this.idUsuarioVisitante});

  @override
  State<ProductosVisitantePagina> createState() => _ProductosVisitanteState();
}

class _ProductosVisitanteState extends State<ProductosVisitantePagina> {
  late int idUsuarioVisitante;

  int opcionSeleccionada = 2; // Perfil es la opción 4

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeneficiosPagina()),
      );
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }

  // Cargar productos
  Future<void> _cargarProductos() async {
    //final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final productoProvider = Provider.of<ProductoProvider>(context, listen: false);

    //final int idUsuario = usuarioProvider.idUsuario ?? 1;
    //print('🔵 Iniciando carga de productos para usuario: $idUsuario');

    //await productoProvider.obtenerProductosVendedor(idUsuario);
    try {
      await productoProvider.obtenerProductosVendedor(idUsuarioVisitante);
      //print('✅ Productos cargados: ${productoProvider.productosVendedor.length}');
      //print('📦 Detalles: ${productoProvider.productosVendedor}');
    } catch (e) {
      //print('❌ Error al cargar productos: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    idUsuarioVisitante = widget.idUsuarioVisitante;
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarProductos();
    });
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
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => PerfilVisitantePagina(idUsuarioVisitante: idUsuarioVisitante)));
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Consumer<ProductoProvider>(
            builder: (context, productoProvider, child) {
              if (productoProvider.productosVendedor.isEmpty) {
                return const Center(child: Text("No hay productos para mostrar"));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final maxCrossAxisExtent =
                      constraints.maxWidth / (constraints.maxWidth > 600 ? 3 : 2);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: maxCrossAxisExtent,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: productoProvider.productosVendedor.length,
                    itemBuilder: (context, index) {
                      final producto = productoProvider.productosVendedor[index];

                      return TarjetaCompraProductos(
                        fotoProducto: producto.urlFoto,
                        nombreProducto: producto.nombre,
                        tipo: producto.tipo,
                        precio: producto.precio.toInt(),
                        idProducto: producto.idProducto,
                        opcion: 2
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
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