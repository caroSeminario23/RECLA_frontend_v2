import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/tabla_clasificacion.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/login.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/utils/ref_imagenes.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/widgets/posiciones_tabla.dart';


class TablaClasificacionPagina extends StatefulWidget {
  const TablaClasificacionPagina({super.key});

  @override
  State<TablaClasificacionPagina> createState() =>
      _TablaClasificacionPaginaState();
}

class _TablaClasificacionPaginaState extends State<TablaClasificacionPagina> {
  int opcionSeleccionada = 2; // Tabla de clasificación es la opción 2
  late String fechaActual;
  int idUsuario = 0;

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    } else if (index == 0) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }


  // Cargar tabla de clasificación
  Future<void> _cargarTablaClasificacion() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final tablaClasificacionProvider = Provider.of<TablaClasificacionProvider>(context, listen: false);

    idUsuario = usuarioProvider.idUsuario ?? 1;
    developer.log('ID USUARIO EN TABLA CLASIFICACION: $idUsuario');

    await tablaClasificacionProvider.mostrarTablaClasificacion();
  }

  @override
  void initState() {
    super.initState();
    fechaActual = DateTime.now().toString().split(' ')[0];
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarTablaClasificacion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'TABLA DE CLASIFICACIÓN',
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
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TÍTULO PRINCIPAL
              Text('RESULTADOS', style: Theme.of(context).textTheme.titleLarge),

              // ESPACIO ENTRE TÍTULO Y SUBTÍTULO
              Text(
                fechaActual,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              // ESPACIO ENTRE TÍTULO Y LÍNEA DIVISORA
              const SizedBox(height: 7),

              // LÍNEA DIVISORA
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),

              // ESPACIO ENTRE LÍNEA Y POSICIONES
              const SizedBox(height: 10),

              Consumer2<TablaClasificacionProvider, UsuarioProvider>(
                builder: (context, tablaClasificacionProvider, usuarioProvider, child) {
                  // Mostrar indicador de carga mientras se obtienen datos
                if (tablaClasificacionProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Mostrar mensaje de error si ocurre
                if (tablaClasificacionProvider.errorMessage != null) {
                  return Center(
                    child: Text(tablaClasificacionProvider.errorMessage!),
                  );
                }

                // Mostrar mensaje si no hay datos
                if (tablaClasificacionProvider.tablaClasificacion.isEmpty) {
                  return const Center(child: Text('No hay datos disponibles'));
                }

                // Transformar los datos al formato esperado por PosicionesTabla
                final posiciones = tablaClasificacionProvider.tablaClasificacion.map((posicion) {
                  return {
                    'imgAprendiz': fotoPerfilPredeterminado,
                    'idUsuario': posicion.idUsuario,
                    'nombreAprendiz': posicion.username,
                    'expAprendiz': posicion.ptosSistema,
                    'puestoAprendiz': posicion.posicion,
                    'seleccionado': posicion.idUsuario == idUsuario,
                  };
                }).toList();

                  return PosicionesTabla(posiciones: posiciones);
                },
              ),
            ],
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