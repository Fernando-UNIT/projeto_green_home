import 'package:flutter/material.dart';
import '../../models/pratica.dart';
import 'detalhe_pratica_page.dart';
import 'nova_pratica_page.dart';
import '../../widgets/pratica_card.dart';
import '../../services/praticas_service.dart';

class PraticasPage extends StatefulWidget {
  const PraticasPage({super.key});

  @override
  State<PraticasPage> createState() => _PraticasPageState();
}

class _PraticasPageState extends State<PraticasPage> {
  final praticasService = PraticasService();
  final TextEditingController buscaController = TextEditingController();
  String busca = '';

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  Future<void> abrirNovaPratica() async {
    final novaPratica = await showModalBottomSheet<Pratica>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NovaPraticaPage(),
    );

    if (novaPratica != null) {
      await praticasService.criarPratica(novaPratica);
    }
  }

  Future<void> abrirDetalhes(Pratica pratica) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetalhePraticaPage(pratica: pratica),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de busca
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

        // Lista de práticas usando stream do Firestore
        Expanded(
          child: StreamBuilder<List<Pratica>>(
            stream: praticasService.listarPraticas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final praticasData = snapshot.data ?? [];
              final praticasFiltradas = praticasData.where((pratica) {
                final textoBusca = busca.toLowerCase();
                return pratica.nome.toLowerCase().contains(textoBusca) ||
                    pratica.categoria.toLowerCase().contains(textoBusca);
              }).toList();

              if (praticasFiltradas.isEmpty) {
                return const Center(child: Text('Nenhuma prática cadastrada'));
              }

              return ListView.builder(
                itemCount: praticasFiltradas.length,
                itemBuilder: (_, index) {
                  final pratica = praticasFiltradas[index];
                  return PraticaCard(
                    pratica: pratica,
                    onTap: () => abrirDetalhes(pratica),
                    onFavoritoTap: () async {
                      pratica.favorita = !pratica.favorita;
                      await praticasService.atualizarPratica(pratica);
                    },
                  );
                },
              );
            },
          ),
        ),

        // Botão nova prática
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