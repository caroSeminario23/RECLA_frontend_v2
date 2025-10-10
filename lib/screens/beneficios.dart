import 'package:flutter/material.dart';

class BeneficiosPagina extends StatefulWidget {
  const BeneficiosPagina({super.key});

  @override
  State<BeneficiosPagina> createState() => _BeneficiosPaginaState();
}

class _BeneficiosPaginaState extends State<BeneficiosPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficios'),
      ),
      body: Center(
        child: Text('Contenido de la página de beneficios'),
      ),
    );
  }
}