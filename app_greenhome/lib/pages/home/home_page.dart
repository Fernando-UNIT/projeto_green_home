import 'package:flutter/material.dart';
import '../../controllers/metas_controller.dart';
import '../../controllers/praticas_controller.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onTapPraticas;

  HomePage({Key? key, required this.onTapPraticas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metasController = MetasController();
    final listaDeMetas = metasController.metas;

    final praticasController = PraticasController();
    final listaDePraticas = praticasController.listar();

    final totalPraticas = listaDePraticas.length;
    final praticasConcluidas = listaDePraticas
        .where((p) => p.concluida == true)
        .length;
    final double progressoCalculado = totalPraticas > 0
        ? praticasConcluidas / totalPraticas
        : 0.0;
    final String progressoTexto = '${(progressoCalculado * 100).toInt()}%';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso Semanal',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final larguraTotal = constraints.maxWidth;
              return Container(
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: larguraTotal * progressoCalculado,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        progressoTexto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Práticas Recentes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildItemCard(
            'Economizar Água',
            Icons.water_drop_outlined,
            Colors.blue,
            onTapPraticas,
          ),
          _buildItemCard(
            'Reciclar Lixo',
            Icons.recycling,
            Colors.green,
            onTapPraticas,
          ),
          _buildItemCard(
            'Apagar Luzes',
            Icons.lightbulb_outline,
            Colors.amber,
            onTapPraticas,
          ),
          const SizedBox(height: 24),
          const Text(
            'Metas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: listaDeMetas.isEmpty
                ? const Text(
                    'Nenhuma meta programada no momento.',
                    style: TextStyle(
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listaDeMetas.map((meta) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                meta.nome,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    String titulo,
    IconData icone,
    Color corIcone,
    VoidCallback clique,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: clique,
        leading: Icon(icone, color: corIcone),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black26),
      ),
    );
  }
}
