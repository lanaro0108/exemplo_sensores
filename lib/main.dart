// Inicialização do aplicativo SENAI CheckIn => registro de ponto com foto e GPS

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Garantir a inicialização dos bindings nativos => necessário para SQLite e sensores
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SenaiCheckInApp());
}

class SenaiCheckInApp extends StatelessWidget {
  SenaiCheckInApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuração principal => define tema e tela inicial da aplicação
    return MaterialApp(
      title: 'SENAI CheckIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF005CAA), // Azul característico do SENAI
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
