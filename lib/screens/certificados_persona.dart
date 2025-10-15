import 'package:flutter/material.dart';

class CertificadosPersonaPagina extends StatefulWidget {
  const CertificadosPersonaPagina({super.key});

  @override
  State<CertificadosPersonaPagina> createState() => _CertificadosPersonaPaginaState();
}

class _CertificadosPersonaPaginaState extends State<CertificadosPersonaPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificados del Usuario'),
      ),
      body: Center(
        child: Text('Contenido de la página de certificados del usuario'),
      ),
    );
  }
}