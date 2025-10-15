import 'package:flutter/material.dart';

class ProductosPersonaPagina extends StatefulWidget {
  const ProductosPersonaPagina({super.key});

  @override
  State<ProductosPersonaPagina> createState() => _ProductosPersonaPaginaState();
}

class _ProductosPersonaPaginaState extends State<ProductosPersonaPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos del Usuario'),
      ),
      body: Center(
        child: Text('Contenido de la página de productos del usuario'),
      ),
    );
  }
}