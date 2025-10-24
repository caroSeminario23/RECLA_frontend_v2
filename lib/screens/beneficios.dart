import 'package:flutter/material.dart';
import 'package:recla/screens/certificados.dart';

import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/insignias.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/recursos_educativos.dart';
import 'package:recla/screens/stickers.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/navbar.dart';

class BeneficiosPagina extends StatefulWidget {
  const BeneficiosPagina({super.key});

  @override
  State<BeneficiosPagina> createState() => _BeneficiosPaginaState();
}

class _BeneficiosPaginaState extends State<BeneficiosPagina> {
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
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'BENEFICIOS Y MARKETPLACE',
          style: Theme.of(context).textTheme.titleMedium,
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
              const SizedBox(height: 8),

              // MISIONES EN CURSO
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Text(
                'MISIONES EN CURSO',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),


              // SECCIÓN: INSIGNIAS
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const InsigniasPagina(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.grade_outlined),
                      label: const Text('Insignias'),
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
                        minimumSize: const Size.fromHeight(100),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),


              // SECCIÓN: CERTIFICADOS
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CertificadosPagina(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.redeem_outlined),
                      label: const Text('Certificados'),
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
                        minimumSize: const Size.fromHeight(100),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),


              // SECCIÓN: RECURSOS EDUCATIVOS
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RecursosEducativosPagina(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.redeem_outlined),
                      label: const Text('Recursos educativos'),
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
                        minimumSize: const Size.fromHeight(100),
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),

              //const SizedBox(height: 8),

              const SizedBox(height: 25),

              // MARKETPLACE
              Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              Text(
                'MARKETPLACE',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StickersPagina(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.grade_outlined),
                      label: const Text('Stickers'),
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
                        minimumSize: const Size.fromHeight(100),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
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