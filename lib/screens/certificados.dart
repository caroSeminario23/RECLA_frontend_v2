import 'package:flutter/material.dart';

class CertificadosPagina extends StatefulWidget {
  const CertificadosPagina({super.key});

  @override
  State<CertificadosPagina> createState() => _CertificadosPaginaState();
}

class _CertificadosPaginaState extends State<CertificadosPagina> {
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