import 'package:flutter/material.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/cadastro_page.dart';
import 'layout/main_layout.dart';

class GreenHomeApp extends StatelessWidget {
  const GreenHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenHome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF34A853),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/home': (context) => const MainLayout(),
      },
    );
  }
}