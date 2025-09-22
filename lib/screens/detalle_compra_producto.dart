import 'package:flutter/material.dart';
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
}