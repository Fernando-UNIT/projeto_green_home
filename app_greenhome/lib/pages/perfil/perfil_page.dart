import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
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
          ],
        ),
      ),
    );
  }
}