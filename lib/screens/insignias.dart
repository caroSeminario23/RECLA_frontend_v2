import 'package:flutter/material.dart';
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
              ColeccionInsignias(
                nombreColeccion: seccionInsignias1['nombreColeccion'],
                nivel: seccionInsignias1['nivel'],
                insignias: seccionInsignias1['insignias'],
                tipoContador: seccionInsignias1['tipoContador'],
                valorContador: seccionInsignias1['valorContador'],
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
              ColeccionInsignias(
                nombreColeccion: seccionInsignias2['nombreColeccion'],
                nivel: seccionInsignias2['nivel'],
                insignias: seccionInsignias2['insignias'],
                tipoContador: seccionInsignias2['tipoContador'],
                valorContador: seccionInsignias2['valorContador'],
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
              ColeccionInsignias(
                nombreColeccion: seccionInsignias3['nombreColeccion'],
                nivel: seccionInsignias3['nivel'],
                insignias: seccionInsignias3['insignias'],
                tipoContador: seccionInsignias3['tipoContador'],
                valorContador: seccionInsignias3['valorContador'],
              ),

              // ESPACIO ENTRE SECCIÓN 3 Y LÍNEA DIVISORA
              const SizedBox(height: 12),

              // LÍNEA DIVISORA
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),

              // ESPACIO ENTRE LÍNEA Y SECCIÓN 4
              const SizedBox(height: 1),

              // SECCIÓN 4
              ColeccionInsignias(
                nombreColeccion: seccionInsignias4['nombreColeccion'],
                nivel: seccionInsignias4['nivel'],
                insignias: seccionInsignias4['insignias'],
                tipoContador: seccionInsignias4['tipoContador'],
                valorContador: seccionInsignias4['valorContador'],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: NavBar(
        opcionSeleccionada: opcionSeleccionada,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}