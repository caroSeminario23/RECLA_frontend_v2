import 'package:flutter/material.dart';

class CuestionarioPagina extends StatelessWidget {
  const CuestionarioPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario'),
      ),
      body: const Center(
        child: Text('Aquí va el contenido del cuestionario.'),
      ),
    );
  }
}