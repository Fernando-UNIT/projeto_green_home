import 'package:flutter/material.dart';
import '../../controllers/praticas_controller.dart';
import '../../models/pratica.dart';
import 'detalhe_pratica_page.dart';
import 'nova_pratica_page.dart';
import '../../widgets/pratica_card.dart';

class PraticasPage extends StatefulWidget {
  const PraticasPage({super.key});

  @override
  State<PraticasPage> createState() => _PraticasPageState();
}

class _PraticasPageState extends State<PraticasPage> {
  final PraticasController controller = PraticasController();
  final TextEditingController buscaController = TextEditingController();

  String busca = '';

  List<Pratica> get praticasFiltradas {
    final praticas = controller.listar();

    if (busca.trim().isEmpty) return praticas;

    return praticas.where((pratica) {
      final textoBusca = busca.toLowerCase();
      return pratica.nome.toLowerCase().contains(textoBusca) ||
          pratica.categoria.toLowerCase().contains(textoBusca);
    }).toList();
  }

  Future<void> abrirNovaPratica() async {
    final novaPratica = await showModalBottomSheet<Pratica>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NovaPraticaPage(),
    );

    if (novaPratica != null) {
      setState(() {
        controller.adicionar(novaPratica);
      });
    }
  }

  Future<void> abrirDetalhes(Pratica pratica) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetalhePraticaPage(
        pratica: pratica,
        onExcluir: () {
          setState(() {
            controller.excluir(pratica.id);
          });
        },
        onAlternarConclusao: () {
          setState(() {
            controller.alternarConclusao(pratica.id);
          });
        },
        onEditar: (praticaAtualizada) {
          setState(() {
            controller.atualizar(praticaAtualizada);
          });
        },
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: buscaController,
            decoration: const InputDecoration(
              hintText: 'Buscar prática...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                busca = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: praticasFiltradas.length,
            itemBuilder: (_, index) {
              final pratica = praticasFiltradas[index];

              return PraticaCard(
                pratica: pratica,
                onTap: () => abrirDetalhes(pratica),
                onFavoritoTap: () {
                  setState(() {
                    controller.alternarFavorito(pratica.id);
                  });
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: abrirNovaPratica,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34A853),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Nova Prática',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}