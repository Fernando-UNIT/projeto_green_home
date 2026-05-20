import 'package:flutter/material.dart';

import '../../controllers/praticas_controller.dart';
import '../../models/pratica.dart';
import '../../widgets/pratica_card.dart';
import 'detalhe_pratica_page.dart';
import 'nova_pratica_page.dart';

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

    if (busca.trim().isEmpty) {
      return praticas;
    }

    return praticas.where((pratica) {
      final textoBusca = busca.toLowerCase();

      return pratica.nome.toLowerCase().contains(textoBusca) ||
          pratica.categoria.toLowerCase().contains(textoBusca);
    }).toList();
  }

  Future<void> abrirNovaPratica() async {
    final novaPratica = await Navigator.push<Pratica>(
      context,
      MaterialPageRoute(
        builder: (_) => const NovaPraticaPage(),
      ),
    );

    if (novaPratica != null) {
      setState(() {
        controller.adicionar(novaPratica);
      });
    }
  }

  Future<void> abrirDetalhes(Pratica pratica) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
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
    final praticas = praticasFiltradas;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        children: [
          TextField(
            controller: buscaController,
            onChanged: (value) {
              setState(() {
                busca = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Buscar prática',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _FiltroBox(
                  titulo: 'Categoria',
                  valor: 'Todas',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FiltroBox(
                  titulo: 'Data',
                  valor: 'Hoje',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Qua, maio. 20',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: praticas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma prática encontrada.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: praticas.length,
                    itemBuilder: (_, index) {
                      final pratica = praticas[index];

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
            padding: const EdgeInsets.only(bottom: 16, top: 6),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: abrirNovaPratica,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text(
                  'Nova Prática',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroBox extends StatelessWidget {
  final String titulo;
  final String valor;

  const _FiltroBox({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}