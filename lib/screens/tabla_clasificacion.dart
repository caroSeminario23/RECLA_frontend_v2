import 'package:flutter/material.dart';

class TablaClasificacionPagina extends StatefulWidget {
  const TablaClasificacionPagina({super.key});

  @override
  State<TablaClasificacionPagina> createState() => _TablaClasificacionPaginaState();
}

class _TablaClasificacionPaginaState extends State<TablaClasificacionPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Clasificación'),
      ),
      body: Center(
        child: Text('Contenido de la página de tabla de clasificación'),
      ),
    );
  }
}