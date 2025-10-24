import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/usuario.dart';
import 'package:recla/providers/certificado.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/grupo_certificados_persona.dart';
import 'package:recla/widgets/navbar.dart';

class CertificadosPersonaPagina extends StatefulWidget {
  const CertificadosPersonaPagina({super.key});

  @override
  State<CertificadosPersonaPagina> createState() => _CertificadosPersonaPaginaState();
}

class _CertificadosPersonaPaginaState extends State<CertificadosPersonaPagina> {
  int opcionSeleccionada = 4; // Certificados es la opción 4

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()),
      );
    } else if (index == 0) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeneficiosPagina()),
      );
    }
  }


  // Cargar certificados
  Future<void> _cargarCertificadosDesbloqueados() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final certificadoProvider = Provider.of<CertificadoProvider>(context, listen: false);

    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    await certificadoProvider.obtenerCertificadosDesbloqueados(idUsuario);
  }

  @override
  void initState() {
    super.initState();
    
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
            ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
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

      bottomNavigationBar: NavBar(
        opcionSeleccionada: opcionSeleccionada,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}