import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/usuario.dart';

import 'package:recla/providers/estatus.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
//import 'package:recla/screens/certificados_persona.dart';
import 'package:recla/screens/certificados_visitante.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
//import 'package:recla/screens/insignias_persona.dart';
import 'package:recla/screens/insignias_visitante.dart';
import 'package:recla/screens/perfil_eco.dart';
//import 'package:recla/screens/productos_persona.dart';
import 'package:recla/screens/productos_visitante.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/utils/ref_imagenes.dart';
import 'package:recla/widgets/barra_puntos.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/widgets/presentacion_usuario.dart';

class PerfilVisitantePagina extends StatefulWidget {
  final int idUsuarioVisitante;

  const PerfilVisitantePagina({super.key, required this.idUsuarioVisitante});

  @override
  State<PerfilVisitantePagina> createState() => _PerfilVisitantePaginaState();
}

class _PerfilVisitantePaginaState extends State<PerfilVisitantePagina> {
  late int idUsuarioVisitante;
  UsuarioUsername? usernameVisita;

  int opcionSeleccionada = 2; // Índice de la opción seleccionada (Perfil)

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    } else if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CompraProductosPagina()),
      );
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }

  // Cargar estatus del usuario
  Future<void> _cargarEstatus() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final estatusProvider = Provider.of<EstatusProvider>(context, listen: false);

    //final int idUsuario = usuarioProvider.idUsuario ?? 1;

    await estatusProvider.cargarEstatusPerfil(idUsuarioVisitante);
    await estatusProvider.cargarEstatusContadores(idUsuarioVisitante);

    final UsuarioUsername? usernameVisita = await usuarioProvider.obtenerUsername(idUsuarioVisitante);
    //print('Username de la visita: ${usernameVisita?.username}');

    setState(() {
      this.usernameVisita = usernameVisita;
    });
  }

  @override
  void initState() {
    super.initState();

    idUsuarioVisitante = widget.idUsuarioVisitante;

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
          'ALIADO ECOAPRENDIZ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()));
          },
        ),
        automaticallyImplyLeading: false,
        
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
                    fotoAprendiz: fotoPerfilPredeterminado,
                    experiencia: estatusProvider.ptosExperiencia ?? 0,
                    nombre: usernameVisita?.username ?? 'Nombre Apellido',
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

            // SECCIÓN INSIGNIAS
            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Text(
              'SUS INSIGNIAS',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // INSIGNIAS
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InsigniasVisitantePagina(idUsuarioVisitante: idUsuarioVisitante),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events_outlined),
              label: const Text('Visualiza mis logros'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(
                      context,
                    ).colorScheme.secondaryContainer, // Fondo verde
                foregroundColor:
                    Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer, // Texto e ícono blancos
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ), // Borde verde oscuro
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Opcional: bordes redondeados
                ),
                minimumSize: const Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(horizontal: 35),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),

            const SizedBox(
              height: 16,
            ), // Espacio entre el estatus y la imagen del puesto
            
            // SECCIÓN CERTIFICADOS
            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Text(
              'SUS CERTIFICADOS',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // CERTIFICADOS
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CertificadosVisitantePagina(idUsuarioVisitante: idUsuarioVisitante),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events_outlined),
              label: const Text('Visualiza mis certificados'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(
                      context,
                    ).colorScheme.secondaryContainer, // Fondo verde
                foregroundColor:
                    Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer, // Texto e ícono blancos
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ), // Borde verde oscuro
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Opcional: bordes redondeados
                ),
                minimumSize: const Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(horizontal: 35),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),

            const SizedBox(
              height: 16,
            ), // Espacio entre el estatus y la imagen del puesto
            
            // SECCIÓN PRODUCTOS
            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Text(
              'SUS PRODUCTOS',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // PRODUCTOS QUE OFRECE
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductosVisitantePagina(idUsuarioVisitante: idUsuarioVisitante),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events_outlined),
              label: const Text('Lo que te ofrezco'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(
                      context,
                    ).colorScheme.secondaryContainer, // Fondo verde
                foregroundColor:
                    Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer, // Texto e ícono blancos
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ), // Borde verde oscuro
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Opcional: bordes redondeados
                ),
                minimumSize: const Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(horizontal: 35),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
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