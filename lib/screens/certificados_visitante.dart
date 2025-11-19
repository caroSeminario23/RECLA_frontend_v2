import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:recla/providers/usuario.dart';
import 'package:recla/providers/certificado.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/perfil_visitante.dart';
//import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/grupo_certificados_persona.dart';
import 'package:recla/widgets/navbar.dart';

class CertificadosVisitantePagina extends StatefulWidget {
  final int idUsuarioVisitante;

  const CertificadosVisitantePagina({super.key, required this.idUsuarioVisitante});

  @override
  State<CertificadosVisitantePagina> createState() => _CertificadosVisitantePaginaState();
}

class _CertificadosVisitantePaginaState extends State<CertificadosVisitantePagina> {
  late int idUsuarioVisitante;

  int opcionSeleccionada = 2; // Certificados es la opción 2

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 0) {
      Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }


  // Cargar certificados
  Future<void> _cargarCertificadosDesbloqueados() async {
    //final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final certificadoProvider = Provider.of<CertificadoProvider>(context, listen: false);

    //final int idUsuario = usuarioProvider.idUsuario ?? 1;

    await certificadoProvider.obtenerCertificadosDesbloqueados(idUsuarioVisitante);
  }

  @override
  void initState() {
    super.initState();
    
    idUsuarioVisitante = widget.idUsuarioVisitante;

    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarCertificadosDesbloqueados();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CERTIFICADOS',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => PerfilVisitantePagina(idUsuarioVisitante: idUsuarioVisitante)));
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<CertificadoProvider>(
                builder: (context, certificadoProvider, child) {
                  return GrupoCertificadosPersona(
                    certificados: certificadoProvider.certificadosDesbloqueadosUsuario,
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