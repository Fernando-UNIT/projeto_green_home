import 'package:flutter/material.dart';
import 'perfil.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  int paginaAtual = 0;

  final List<Widget> paginas = [

    const Center(
      child: Text('Início'),
    ),

    const Center(
      child: Text('Práticas'),
    ),

    const Center(
      child: Text('Metas'),
    ),

    const Center(
      child: Text('Dicas'),
    ),

    const Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF34A853),
        elevation: 0,
        title: const Text(
          'GreenHome',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: paginas[paginaAtual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        backgroundColor:const Color.fromARGB(235, 255, 255, 255),
        selectedItemColor:const Color(0xFF34A853),
        unselectedItemColor:
            const Color.fromARGB(136, 80, 80, 80),
        onTap: (index) {

          setState(() {

            paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Início',),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline),label: 'Práticas',),
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed),label: 'Metas',),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline),label: 'Dicas',),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Perfil',),
        ],
      ),
    );
  }
}