import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF34A853),
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFF1F8F45),
                child: Icon(
                  Icons.person_outline,
                  size: 90,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        selectedItemColor: const Color(0xFF34A853),
        unselectedItemColor: const Color.fromARGB(136, 80, 80, 80),
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Início',),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline),label: 'Práticas',),
        BottomNavigationBarItem(icon: Icon(Icons.gps_fixed),label: 'Metas',),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline),label: 'Dicas',),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Perfil',),
        ],
        onTap: (index) {
        if (index == 4) {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const Perfil(),),
            );
            }
        if (index == 0) {
        Navigator.pop(context);
        }
        },
      ),
    );
  }
}