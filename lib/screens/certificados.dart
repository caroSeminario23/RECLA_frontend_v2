import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/providers/certificado.dart';
import 'package:recla/widgets/grupo_certificados.dart';
import 'package:recla/widgets/navbar.dart';

class CertificadosPagina extends StatefulWidget {
  const CertificadosPagina({super.key});

  @override
  State<CertificadosPagina> createState() => _CertificadosPaginaState();
}

class _CertificadosPaginaState extends State<CertificadosPagina> {
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


  // Cargar certificados
  Future<void> _cargarCertificados() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final certificadoProvider = Provider.of<CertificadoProvider>(context, listen: false);

    final int idUsuario = usuarioProvider.idUsuario ?? 1;

    await certificadoProvider.obtenerCertificados(idUsuario);
  }

  @override
  void initState() {
    super.initState();
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarCertificados();
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
              Consumer<CertificadoProvider>(
                builder: (context, certificadoProvider, child) {
                  return GrupoCertificados(
                    certificados: certificadoProvider.certificados,
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