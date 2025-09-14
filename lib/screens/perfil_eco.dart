import 'package:flutter/material.dart';

class PerfilEcoPagina extends StatefulWidget {
  const PerfilEcoPagina({super.key});

  @override
  State<PerfilEcoPagina> createState() => _PerfilEcoPaginaState();
}

class _PerfilEcoPaginaState extends State<PerfilEcoPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Ecológico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí puedes agregar widgets para mostrar la información del perfil
            const Text('Información del perfil ecológico'),
          ],
        ),
      ),
    );
  }
}