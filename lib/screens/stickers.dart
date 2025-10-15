import 'package:flutter/material.dart';

class StickersPagina extends StatefulWidget {
  const StickersPagina({super.key});

  @override
  State<StickersPagina> createState() => _StickersPaginaState();
}

class _StickersPaginaState extends State<StickersPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stickers del Usuario'),
      ),
      body: Center(
        child: Text('Contenido de la página de stickers del usuario'),
      ),
    );
  }
}