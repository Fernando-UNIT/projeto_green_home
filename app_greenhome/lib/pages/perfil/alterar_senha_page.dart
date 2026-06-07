import 'package:flutter/material.dart';
import '../../controllers/usuario_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final UsuarioController controller = UsuarioController();     // Controllers responsável pelas regras de negócio e dos campos de texto
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
            campoSenha(  //Campos para inserior a senha atual e nova senha
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
                onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                final loginComGoogle = user?.providerData.any((provider) => provider.providerId == 'google.com',  //verifica se o login foi realizado com Google
                    ) ??
                    false;

                if (loginComGoogle) {         //bloqueia alteração de senha para contas Google
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Contas que entraram pelo Google devem alterar a senha diretamente na conta Google.',
                      ),
                    ),
                  );
                  return;
                }
                String? resultado = await controller.alterarSenha(     //envia os dados para o controller realizar as validações
                  senhaAtual: senhaAtualController.text,
                  novaSenha: novaSenhaController.text,
                  confirmarSenha: confirmarSenhaController.text,
                );

                if (!context.mounted) return;

                if (resultado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Senha alterada com sucesso!',),
                    ),
                  );
                  senhaAtualController.clear();
                  novaSenhaController.clear();
                  confirmarSenhaController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(resultado),),
                  );
                }
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