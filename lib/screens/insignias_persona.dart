import 'package:flutter/material.dart';

class InsigniasPersonaPagina extends StatefulWidget {
  const InsigniasPersonaPagina({super.key});

  @override
  State<InsigniasPersonaPagina> createState() => _InsigniasPersonaPaginaState();
}

class _InsigniasPersonaPaginaState extends State<InsigniasPersonaPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insignias del Usuario'),
      ),
      body: Center(
        child: Text('Contenido de la página de insignias del usuario'),
      ),
    );
  }
}