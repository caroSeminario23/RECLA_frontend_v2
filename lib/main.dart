import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/usuario.dart';
import 'config/theme.dart';
import 'screens/bienvenida.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RECLA',
      theme: AppTheme.lightTheme(),
      home: const BienvenidaScreen()
      //home: const Login()
      //home: const PerfilEcoPagina(),
      //home: const EstatusScreen()
    );
  }
}