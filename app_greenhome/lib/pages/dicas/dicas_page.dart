// pages/dicas/dicas_page.dart
import 'package:flutter/material.dart';
import '../../models/dica.dart';
import '../../services/dicas_service.dart';
import '../../controllers/dicas_controller.dart';
import '../../widgets/dica_card.dart'; 

class DicasPage extends StatefulWidget {
  const DicasPage({super.key});

  @override
  State<DicasPage> createState() => _DicasPageState();
}

class _DicasPageState extends State<DicasPage> {
  final DicasController _dicasController = DicasController();
  bool mostrarSomenteFavoritos = false;
  
  // Carrega as dicas que o ADM colocou no código fonte
  final List<Dica> dicasDoAdm = DicasService.getDicas();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Dicas',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
        
        // STREAMBUILDER conectando com a tabela 'dicas_favoritas'
        Expanded(
          child: StreamBuilder<List<String>>(
            stream: _dicasController.favoritosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.green));
              }

              // Lista com os IDs que o usuário favoritou no Firebase (ex: ['agua_1'])
              final favoritosDoBanco = snapshot.data ?? [];

              // Atualiza nossa lista local dizendo quem é favorito baseado no banco
              for (var dica in dicasDoAdm) {
                dica.favorito = favoritosDoBanco.contains(dica.id);
              }

              final totalFavoritos = dicasDoAdm.where((d) => d.favorito).length;

              // Filtra se o usuário clicar no botão "Favoritas"
              final dicasExibidas = mostrarSomenteFavoritos
                  ? dicasDoAdm.where((d) => d.favorito).toList()
                  : dicasDoAdm;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('Todas'),
                          selected: !mostrarSomenteFavoritos,
                          onSelected: (_) => setState(() => mostrarSomenteFavoritos = false),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text('Favoritas ($totalFavoritos)'),
                          selected: mostrarSomenteFavoritos,
                          onSelected: (_) => setState(() => mostrarSomenteFavoritos = true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Expanded(
                    child: dicasExibidas.isEmpty
                        ? const Center(child: Text('Nenhuma dica para exibir.'))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            itemCount: dicasExibidas.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 16),
                            itemBuilder: (_, index) {
                              final dica = dicasExibidas[index];

                              return DicaCard(
                                dica: dica,
                                onFavoritoPressed: () {
                                  // Grava ou deleta no Firebase em tempo real
                                  _dicasController.alternarFavorito(dica.id, dica.favorito);
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}