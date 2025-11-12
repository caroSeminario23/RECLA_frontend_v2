import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/estatus.dart';
import 'package:recla/providers/insignia.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/coleccion_insignias.dart';
import 'package:recla/widgets/navbar.dart';

class InsigniasPagina extends StatefulWidget {
  const InsigniasPagina({super.key});

  @override
  State<InsigniasPagina> createState() => _InsigniasPaginaState();
}

class _InsigniasPaginaState extends State<InsigniasPagina> {
  int opcionSeleccionada = 1;
  int puntosCompra = 0;
  int puntosVenta = 0;
  int puntosRecEducativos = 0;

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
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()),
      );
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    }
  }


  // Cargar insignias
  Future<void> _cargarInsignias() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final insigniaProvider = Provider.of<InsigniaProvider>(context, listen: false);
    //final estatusProvider = Provider.of<EstatusProvider>(context, listen: false);

    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    setState(() {
      //puntosCompra = estatusProvider.ptosCompras ?? 0;
      //puntosVenta = estatusProvider.ptosVentas ?? 0;
      //puntosRecEducativos = estatusProvider.ptosRecEducativos ?? 0;
    });

    await insigniaProvider.obtenerInsignias(idUsuario, 1); //compras
    //print("Insignias compra: ${insigniaProvider.insigniasCompra.length}");
    await insigniaProvider.obtenerInsignias(idUsuario, 2); //ventas
    //print("Insignias venta: ${insigniaProvider.insigniasVenta.length}");
    await insigniaProvider.obtenerInsignias(idUsuario, 3); //recursos educativos
    //print("Insignias recursos educativos: ${insigniaProvider.insigniasRecursos.length}");
  }

  @override
  void initState() {
    super.initState();
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarInsignias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'INSIGNIAS',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LÍNEA DIVISORA
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),

              // ESPACIO ENTRE LÍNEA Y SECCIÓN 1
              const SizedBox(height: 1),

              // SECCIÓN 1
              Consumer<EstatusProvider>(
                builder: (context, estatusProvider, child) {
                  return Consumer<InsigniaProvider>(
                    builder: (context, insigniaProvider, child) {
                      return ColeccionInsignias(
                        nombreColeccion: "Comprador consciente",
                        insignias: insigniaProvider.insigniasCompra,
                        tipoContador: 1,
                        valorContador: estatusProvider.ptosCompras ?? 0,
                      );
                    },
                  );
                },
              ),

              // ESPACIO ENTRE SECCIÓN 1 Y LÍNEA DIVISORA
              const SizedBox(height: 12),

              // LÍNEA DIVISORA
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),

              // ESPACIO ENTRE LÍNEA Y SECCIÓN 2
              const SizedBox(height: 1),

              // SECCIÓN 2
              Consumer<EstatusProvider>(
                builder: (context, estatusProvider, child) {
                  return Consumer<InsigniaProvider>(
                    builder: (context, insigniaProvider, child) {
                      return ColeccionInsignias(
                        nombreColeccion: "Vendedor consciente",
                        insignias: insigniaProvider.insigniasVenta,
                        tipoContador: 2,
                        valorContador: estatusProvider.ptosVentas ?? 0,
                      );
                    },
                  );
                },
              ),

              // ESPACIO ENTRE SECCIÓN 2 Y LÍNEA DIVISORA
              const SizedBox(height: 12),

              // LÍNEA DIVISORA
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),

              // ESPACIO ENTRE LÍNEA Y SECCIÓN 3
              const SizedBox(height: 1),

              // SECCIÓN 3
              Consumer<EstatusProvider>(
                builder: (context, estatusProvider, child) {
                return Consumer<InsigniaProvider>(
                  builder: (context, insigniaProvider, child) {
                    return ColeccionInsignias(
                      nombreColeccion: "Ecoaprendiz informado",
                      insignias: insigniaProvider.insigniasRecursos,
                      tipoContador: 3,
                      valorContador: estatusProvider.ptosRecEducativos ?? 0,
                    );
                  },
                );
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