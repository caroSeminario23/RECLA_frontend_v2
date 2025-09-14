import 'package:flutter/material.dart';
import 'login.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  static const splashDuration = Duration(seconds: 3);
  
  @override
  void initState() {
    super.initState();
    Future.delayed(splashDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo-principal.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}