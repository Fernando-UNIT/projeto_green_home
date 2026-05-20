import 'package:flutter/material.dart';
import '../pages/perfil/perfil_page.dart';
import '../pages/dicas/dicas_page.dart';
import '../pages/perfil/alterar_senha_page.dart';
import '../pages/metas/metas_page.dart';
import '../pages/praticas/praticas_page.dart';
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});


  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int paginaAtual = 0;
  bool mostrandoPerfil = false;
  bool mostrandoAlterarSenha = false;

  void abrirAlterarSenha() {

    setState(() {

      mostrandoPerfil = true;
      mostrandoAlterarSenha = true;

    });
  }

  void voltarParaPerfil() {

  setState(() {

    mostrandoAlterarSenha = false;
    mostrandoPerfil = true;

  });
}
  
  final List<Widget> paginas = [
    const Center(
      child: Text('Início'),
    ),
    const PraticasPage(),
    const MetasPage(),
    const DicasPage(),
  ];

  final List<String> titulos = [
    'Olá',
    'Práticas',
    'Metas',
    'Dicas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: mostrandoAlterarSenha
        ? IconButton(
            onPressed: voltarParaPerfil,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )
        : null,
        title: Text(
          mostrandoAlterarSenha
              ? 'Alterar senha'
              : mostrandoPerfil
                  ? 'Perfil'
                  : titulos[paginaAtual],
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: mostrandoPerfil
                  ? Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        hoverColor: Colors.grey.shade200,
                        onTap: () {},
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF2A914D),
                            size: 32,
                          ),
                        ),
                      ),
                    )
                  : Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(21),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        hoverColor: Colors.white.withValues(alpha: 0.2),
                        onTap: () {
                          setState(() {
                            mostrandoPerfil = true;
                          });
                        },
                        child: const Icon(
                          Icons.account_circle,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
              colors: [
                Color(0xFF46C971),
                Color(0xFF2A914D),
              ],
            ),
          ),
        ),
      ),
      body: mostrandoAlterarSenha
      ? const AlterarSenhaPage()
      : mostrandoPerfil
          ? Perfil(
              onEditarSenha: abrirAlterarSenha,
            )
          : paginas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        selectedItemColor: mostrandoPerfil
            ? const Color.fromARGB(136, 80, 80, 80)
            : const Color(0xFF34A853),
        unselectedItemColor: const Color.fromARGB(136, 80, 80, 80),
        onTap: (index) {
          setState(() {
            paginaAtual = index;
            mostrandoPerfil = false;
            mostrandoAlterarSenha = false;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'Início',),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined),label: 'Práticas',),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes),label: 'Metas',),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline),label: 'Dicas',),
        ],
      ),
    );
  }
}