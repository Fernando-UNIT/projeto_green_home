import 'package:flutter/material.dart';
import '../../controllers/usuario_controller.dart';
import '../../models/usuario.dart';
import '../auth/login_page.dart';

class Perfil extends StatefulWidget {
  final VoidCallback onEditarSenha;

  const Perfil({
    super.key,
    required this.onEditarSenha,
  });

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final UsuarioController controller = UsuarioController(); //responsável pela comunicação com service/firebase
  Future<Usuario>? usuarioFuture; //armazena os dados do usuário

  @override
  void initState() {
    super.initState();
    usuarioFuture = controller.buscarUsuario(); //Busca os dados do usuário logado no firebase
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario>(
      future: usuarioFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString(),),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('Erro ao carregar usuário',),
          );
        }
        final usuario = snapshot.data!;  //mostra os dados retornados do firebase
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
                  child: Icon( Icons.person_outline, size: 90, color: Colors.white, ),
                ),
                const SizedBox(height: 50),
                campoPerfil(              //campos que mostram as infirmacoes do usuario
                  icone: Icons.email_outlined,
                  titulo: 'E-mail',
                  valor: usuario.email,
                ),
                const SizedBox(height: 20),
                campoPerfil(
                  icone: Icons.person_outline,
                  titulo: 'Nome de usuário',
                  valor: usuario.nome,
                ),
                const SizedBox(height: 20),
                campoPerfil(
                  icone: Icons.key_outlined,
                  titulo: 'Senha',
                  valor: '************',
                  mostrarBotaoEditar: true,
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage(),),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Sair da conta',
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
      },
    );
   }

  Widget campoPerfil({
    required IconData icone,
    required String titulo,
    required String valor,
    bool mostrarBotaoEditar = false,
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
          Icon(icone, size: 28,),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 56, 56, 56,),
                  ),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(133, 43, 43, 43,),
                  ),
                ),
              ],
            ),
          ),
          if (mostrarBotaoEditar)
            IconButton(
              onPressed: widget.onEditarSenha,
              icon: const Icon( Icons.edit_outlined,),
            ),
        ],
      ),
    );
  }
}