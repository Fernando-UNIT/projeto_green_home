
import 'package:flutter/material.dart';

import '../../controllers/usuario_controller.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() =>
      _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {

  final UsuarioController controller = UsuarioController();
  final TextEditingController senhaAtualController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
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
            campoSenha(
              titulo: 'Senha atual',
              hint: 'Digite sua senha',
              controller: senhaAtualController,
            ),
            const SizedBox(height: 20),
            campoSenha(
              titulo: 'Nova senha',
              hint: 'Digite a nova senha',
              controller: novaSenhaController,
            ),
            const SizedBox(height: 20),
            campoSenha(
              titulo: 'Confirmar nova senha',
              hint: 'Confirme sua nova senha',
              controller: confirmarSenhaController,
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  controller.alterarSenha(
                    senhaAtual: senhaAtualController.text,
                    novaSenha: novaSenhaController.text,
                    confirmarSenha: confirmarSenhaController.text,
                  );
                  print(senhaAtualController.text,);
                  print(novaSenhaController.text,);
                  print(confirmarSenhaController.text,);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Alterar Senha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget campoSenha({
    required String titulo,
    required String hint,
    required TextEditingController
        controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(2, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.key_outlined, size: 28,),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB( 255, 56, 56, 56,),
                  ),
                ),
                TextField(
                  controller: controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle:
                        const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(133, 43, 43, 43,),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 43, 43, 43,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}