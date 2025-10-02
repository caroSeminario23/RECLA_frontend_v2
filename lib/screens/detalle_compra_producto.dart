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

/*import 'package:flutter/material.dart';
import 'package:recla/widgets/boton_precio.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:recla/widgets/componente_detalles_y_comprar.dart';
import 'package:recla/widgets/navbar.dart';



class DetalleCompraProducto extends StatefulWidget {
  final int id;
  const DetalleCompraProducto({super.key, required this.id});

  @override
  State<DetalleCompraProducto> createState() => _DetalleCompraProductoState();
}

class _DetalleCompraProductoState extends State<DetalleCompraProducto> {
  /*int opcionSeleccionada = 0; // La opción 0 es de compra productos
  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    }
  }*/

  @override
  Widget build(BuildContext context) {
    // BUSCA EL PRODUCTO POR ID
    // Asegúrate de que 'datosCompraProductos' sea una lista de mapas con claves 'id', 'foto_producto', 'nombre_producto', etc.
    
    /*final producto = datosCompraProductos.firstWhere(
      (prod) => prod['id'] == widget.id,
    );*/

    // Asumiendo que los datos de tipo compra están dentro del producto bajo la clave 'tipo_compra'
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'COMPRA DE PRODUCTOS',
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
                //producto:['nombre_producto'],
                'Nombre del producto',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width:
                    MediaQuery.of(
                      context,
                    ).size.width, // Ocupa todo el ancho de la pantalla
                height:
                    MediaQuery.of(context).size.height *
                    0.25, // Ocupa el 25% de la altura de la pantalla
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Bordes redondeados
                    border: Border.all(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primary, // Color del marco
                      width: 3, // Grosor del marco
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Bordes redondeados para la imagen
                    child: Image.network(
                      //producto['foto_producto'], // URL de la imagen
                      'https://i.ytimg.com/vi/28U808zFrVo/maxresdefault.jpg',
                      fit:
                          BoxFit
                              .cover, // Ajusta la imagen para cubrir el espacio disponible
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Permite el desplazamiento horizontal
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly, // Ajusta la alineación horizontal
                  children: [
                    BotonesTipo(
                      material: 1, // producto['material'] ?? 0,
                      producto: 2, // producto['producto'] ?? 0,
                    ),
                    const SizedBox(width: 8), // Espacio entre los botones
                    BotonesTipoMaterial(
                      plastico: 1, // producto['plastico'] ?? 0,
                      carton: 2, // producto['carton'] ?? 0,
                      metal: 3, // producto['metal'] ?? 0,
                      vidrio: 4, // producto['vidrio'] ?? 0,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: BotonPrecio(
                  precio:
                      '\$50', //producto['precio'].toString() // Asegúrate de que el precio sea un String,
                  //precio: producto['precio'].toString() // Asegúrate de que el precio sea un String,
                ),
              ),
              //llamar a detalles y comprar
              const SizedBox(height: 10),
              //Linea horizontal que separa los detalles del producto
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              DetalleYComprarProducto(
                idProducto:
                    1,
                //idProducto: producto['id'], // ID del producto que deseas mostrar
                onPressed: () {
                  // Acción al presionar el botón
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto comprado')),
                  );
                },
              ),
              //const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              // Aquí puedes agregar más widgets o información relacionada con el producto
              //TarjetaComentario(id: producto['id']),
            ],
          ),
          
          
        ),
      ),

      /*bottomNavigationBar: NavBar(
        opcionSeleccionada: opcionSeleccionada,
        onItemTapped: _onItemTapped,
        ),*/
    );
  }
}*/