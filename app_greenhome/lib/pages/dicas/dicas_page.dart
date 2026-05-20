//dicas_page.dart
import 'package:flutter/material.dart';
import '../../models/dica.dart';
import '../../services/dicas_service.dart';
import '../../widgets/dica_card.dart';

class DicasPage extends StatefulWidget {
  const DicasPage({super.key});

  @override
  State<DicasPage> createState() => _DicasPageState();
}
class _DicasPageState extends State<DicasPage> {
  bool mostrarSomenteFavoritos = false;

  final List<Dica> dicas = DicasService.getDicas();

  int get totalFavoritos =>
      dicas.where((d) => d.favorito).length;

  List<Dica> get dicasExibidas =>
      mostrarSomenteFavoritos
          ? dicas.where((d) => d.favorito).toList()
          : dicas;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Dicas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todas'),
                selected: !mostrarSomenteFavoritos,
                onSelected: (_) {
                  setState(() {
                    mostrarSomenteFavoritos = false;
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(
                  'Favoritas ($totalFavoritos)',
                ),
                selected: mostrarSomenteFavoritos,
                onSelected: (_) {
                  setState(() {
                    mostrarSomenteFavoritos = true;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: dicasExibidas.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma dica favoritada ainda.',
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: dicasExibidas.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 16),
                  itemBuilder: (_, index) {
                    final dica = dicasExibidas[index];

                    return DicaCard(
                      dica: dica,
                      onFavoritoPressed: () {
                        setState(() {
                          dica.favorito =
                              !dica.favorito;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}