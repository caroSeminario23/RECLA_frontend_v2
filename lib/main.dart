import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:recla/providers/usuario.dart';
import 'package:recla/config/theme.dart';
import 'package:recla/screens/bienvenida.dart';

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

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''), // Español
      ],

      theme: AppTheme.lightTheme(),
      home: const BienvenidaScreen()
      //home: const Login()
      //home: const PerfilEcoPagina(),
      //home: const EstatusScreen()
    );
  }
}