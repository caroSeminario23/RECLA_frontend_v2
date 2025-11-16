import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/recurso_educativo.dart';
import 'package:recla/providers/recurso_educativo.dart';

import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/grupo_rec_educativos.dart';
import 'package:recla/widgets/navbar.dart';

class RecursosEducativosPagina extends StatefulWidget {
  const RecursosEducativosPagina({super.key});

  @override
  State<RecursosEducativosPagina> createState() => _RecursosEducativosPaginaState();
}

class _RecursosEducativosPaginaState extends State<RecursosEducativosPagina> {
  int opcionSeleccionada = 1; // Beneficios es la opción 1
  List<RecursoEducativoPortada> portadasRecEdu = [];

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
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }

  // Cargar portadas de recursos educativos
  Future<void> _cargarRecursosEducativos() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final recursoEducativoProvider = Provider.of<RecursoEducativoProvider>(context, listen: false);

    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    final portadasRecEdu = await recursoEducativoProvider.presentarPortadasRecEducativos(idUsuario);

    setState(() {
      this.portadasRecEdu = portadasRecEdu;
    });
  }

  @override
  void initState() {
    super.initState();
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarRecursosEducativos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'RECURSOS EDUCATIVOS',
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
              Consumer<RecursoEducativoProvider>(
                builder: (context, recEduProvider, child) {
                  return GrupoREducativos(
                    recursos: portadasRecEdu,
                  );
                }
              )
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