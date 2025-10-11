import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/estatus.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/utils/servicios_externos.dart';
import 'package:recla/widgets/barra_puntos.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/widgets/presentacion_usuario.dart';

class PerfilEcoPagina extends StatefulWidget {
  const PerfilEcoPagina({super.key});

  @override
  State<PerfilEcoPagina> createState() => _PerfilEcoPaginaState();
}

class _PerfilEcoPaginaState extends State<PerfilEcoPagina> {
  int opcionSeleccionada = 4; // Índice de la opción seleccionada (Perfil)

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    } else if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()));
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CompraProductosPagina()),
      );
    }
  }

  // Cargar estatus del usuario
  Future<void> _cargarEstatus() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final estatusProvider = Provider.of<EstatusProvider>(context, listen: false);

    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    await estatusProvider.cargarEstatusPerfil(idUsuario);
    await estatusProvider.cargarEstatusContadores(idUsuario);
  }

  @override
  void initState() {
    super.initState();
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEstatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PERFIL ECOAPRENDIZ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/ar_stickers.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad en desarrollo')),
              );
            },
          ),
        ],
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //DATOS DEL USUARIO
            Center(
              child: Consumer2<EstatusProvider, UsuarioProvider>(
                builder: (context, estatusProvider, usuarioProvider, child) {
                  return PresentacionUsuario(
                    fotoAprendiz: perfilPredeterminado,
                    experiencia: estatusProvider.ptosExperiencia ?? 0,
                    nombre: usuarioProvider.username ?? 'Nombre Apellido',
                  );
                },
              ),
            ),

            const SizedBox(height: 16), // Espacio entre la foto y el estatus
            //ESTATUS DEL USUARIO
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<EstatusProvider>(
                    builder: (context, estatusProvider, child) {
                      return BarraPuntos(
                        racha: estatusProvider.racha ?? 0,
                        ptosCompras: estatusProvider.ptosCompras ?? 0,
                        ptosVentas: estatusProvider.ptosVentas ?? 0,
                        ptosRecEducativos: estatusProvider.ptosRecEducativos ?? 0,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 16,
            ), // Espacio entre el estatus y la imagen del puesto
            // DIVIDER
            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),

            const SizedBox(
              height: 55,
            ), // Espacio entre el divider y las insignias

            // BOTÓN PARA EDITAR PERFIL
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad en desarrollo'),
                    ),
                  );
                },
                mini: false,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                child: const Icon(Icons.edit, size: 18),
              ),
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