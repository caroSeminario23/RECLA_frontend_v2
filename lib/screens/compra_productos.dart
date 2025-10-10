import 'package:flutter/material.dart';

class CompraProductosPagina extends StatefulWidget {
  const CompraProductosPagina({super.key});

  @override
  State<CompraProductosPagina> createState() => _CompraProductosPaginaState();
}

class _CompraProductosPaginaState extends State<CompraProductosPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compra de Productos'),
      ),
      body: Center(
        child: Text('Contenido de la página de compra de productos'),
      ),
    );
  }
}