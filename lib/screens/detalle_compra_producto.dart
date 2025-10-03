import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/widgets/boton_precio.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:recla/widgets/componente_detalles_y_comprar.dart';

class DetalleCompraProducto extends StatefulWidget {
  final int id;
  const DetalleCompraProducto({super.key, required this.id});

  @override
  State<DetalleCompraProducto> createState() => _DetalleCompraProductoState();
}

class _DetalleCompraProductoState extends State<DetalleCompraProducto> {
  ProductoDetalleResponse? _detalleProducto;
  ProductoFiltradoResponse? _producto;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDetalleProducto();
    });
    //_cargarDetalleProducto();
  }

  Future<void> _cargarDetalleProducto() async {
    try {
      final productoProvider = Provider.of<ProductoProvider>(context, listen: false);
      print('Buscando producto con ID: ${widget.id}');
      print('Lista filtrada tiene ${productoProvider.productosFiltrados.length} productos');
      // Buscar producto básico de la lista filtrada
      _producto = productoProvider.productosFiltrados
          .firstWhere((prod) => prod.idProducto == widget.id);
      print('Producto encontrado: ${_producto?.nombre}');
      // Obtener detalles adicionales
      _detalleProducto = await productoProvider.detalleP(widget.id);
      //mostrar detalles en consola
      print('idProducto: ${_detalleProducto?.idProducto}');
      print('idvendedor: ${_detalleProducto?.idVendedor}');
      print('Descripción del producto: ${_detalleProducto?.descripcion}');
      
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar producto: $e')),
        );
      }
    }
  }

  List<String> _convertirMaterialALista(String materialString) {
    return materialString.split(',').map((e) => e.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cargando...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_producto == null || _detalleProducto == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Producto no encontrado')),
      );
    }

    final materiales = _convertirMaterialALista(_detalleProducto!.material);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'DETALLE DEL PRODUCTO',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _producto!.nombre,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _producto!.urlFoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BotonesTipo(
                      material: _producto!.tipo == 1 ? 1 : 0,
                      producto: _producto!.tipo == 2 ? 1 : 0,
                      onSelect: (tipo) {}, // Solo mostrar, no permitir selección
                    ),
                    const SizedBox(width: 8),
                    BotonesTipoMaterial(
                      plastico: materiales.contains('1') ? 1 : 0,
                      carton: materiales.contains('2') ? 1 : 0,
                      metal: materiales.contains('3') ? 1 : 0,
                      vidrio: materiales.contains('4') ? 1 : 0,
                      onSelect: (material) {}, // Solo mostrar, no permitir selección
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: BotonPrecio(
                  precio: '\$${_producto!.precio.toInt()}',
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.grey, thickness: 1),
              DetalleYComprarProducto(
                idProducto: widget.id,
                descripcion: _detalleProducto!.descripcion,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto comprado')),
                  );
                },
              ),
              const Divider(color: Colors.grey, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}

