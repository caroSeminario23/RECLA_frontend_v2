import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/usuario.dart';
import 'package:recla/providers/stickers.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/coleccion_stickers.dart';
import 'package:recla/widgets/navbar.dart';

class StickersPagina extends StatefulWidget {
  const StickersPagina({super.key});

  @override
  State<StickersPagina> createState() => _StickersPaginaState();
}

class _StickersPaginaState extends State<StickersPagina> {
  int opcionSeleccionada = 1; // Beneficios es la opción 1

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
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    }
  }

  // Cargar stickers
  Future<void> _cargarStickers() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final stickerProvider = Provider.of<StickerProvider>(context, listen: false);

    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    await stickerProvider.obtenerStickers(idUsuario, 1); //emociones
    await stickerProvider.obtenerStickers(idUsuario, 2); //reacciones
    await stickerProvider.obtenerStickers(idUsuario, 3); //actividades
  }

  @override
  void initState() {
    super.initState();
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarStickers();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('STICKERS', style: Theme.of(context).textTheme.titleMedium),
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
              Consumer<StickerProvider>(
                builder: (context, stickerProvider, child) {
                  return ColeccionStickers(
                    nombreColeccion: "Emociones",
                    stickers: stickerProvider.stickerEmociones,
                  );
                }
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
              Consumer<StickerProvider>(
                builder: (context, stickerProvider, child) {
                  return ColeccionStickers(
                    nombreColeccion: "Reacciones",
                    stickers: stickerProvider.stickerReacciones,
                  );
                }
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

              // SECCIÓN 3
              Consumer<StickerProvider>(
                builder: (context, stickerProvider, child) {
                  return ColeccionStickers(
                    nombreColeccion: "Actividades",
                    stickers: stickerProvider.stickerActividades,
                  );
                }
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