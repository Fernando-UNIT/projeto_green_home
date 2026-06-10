import 'package:flutter/material.dart';
import '../../models/meta.dart';
import '../../models/pratica.dart';
import '../../controllers/metas_controller.dart';
import '../../services/praticas_service.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onTapPraticas;
  final VoidCallback? onTapMetas;

  const HomePage({super.key, this.onTapPraticas, this.onTapMetas});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final praticasService = PraticasService();
  final metasController = MetasController();

  //icones
  Widget _buildIconeCategoria(String categoria) {
    String cat = categoria.toLowerCase();

    if (cat.contains('recicla')) {
      return CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.2),
        child: const Icon(Icons.recycling, color: Colors.green),
      );
    } else if (cat.contains('consumo') ||
        cat.contains('água') ||
        cat.contains('agua')) {
      return CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.2),
        child: const Icon(Icons.water_drop, color: Colors.blue),
      );
    } else if (cat.contains('energia') || cat.contains('luz')) {
      return CircleAvatar(
        backgroundColor: Colors.amber.withOpacity(0.2),
        child: const Icon(Icons.lightbulb_outline, color: Colors.amber),
      );
    } else {
      return CircleAvatar(
        backgroundColor: const Color(0xFF46C971).withOpacity(0.2),
        child: const Icon(Icons.check_circle_outline, color: Color(0xFF2A914D)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<List<Pratica>>(
          stream: praticasService.listarPraticas(),
          builder: (context, snapshot) {
            // load de busca os dados
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF46C971)),
              );
            }

            //progresso semanal (barrinha)
            List<Pratica> praticas = snapshot.data ?? [];
            int totalPraticas = praticas.length;
            int praticasConcluidas = praticas.where((p) => p.concluida).length;

            double progresso = totalPraticas > 0
                ? (praticasConcluidas / totalPraticas)
                : 0.0;
            int porcentagem = (progresso * 100).round();

            // exibe as praticas mais recentes (maximo de 3)
            List<Pratica> praticasRecentes = praticas.reversed.take(3).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
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
                  const SizedBox(height: 12),
                  Container(
                    height: 28,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progresso,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF46C971),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              '$porcentagem%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Práticas Recentes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (praticasRecentes.isEmpty)
                    const Text(
                      'Nenhuma prática registrada ainda.',
                      style: TextStyle(
                        color: Colors.black45,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    ...praticasRecentes.map((pratica) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        color: const Color(0xFFF5F5F5),
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          hoverColor: Colors.black.withOpacity(0.04),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: _buildIconeCategoria(pratica.categoria),
                          title: Text(
                            pratica.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(pratica.categoria),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            if (widget.onTapPraticas != null) {
                              widget.onTapPraticas!();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: 32),

                  const Text(
                    'Metas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<List<Meta>>(
                    stream: metasController.metasStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF46C971),
                          ),
                        );
                      }

                      List<Meta> listaMetas = snapshot.data ?? [];

                      return Material(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {
                            if (widget.onTapMetas != null) {
                              widget.onTapMetas!();
                            }
                          },
                          hoverColor: Colors.black.withOpacity(0.04),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: listaMetas.isEmpty
                                ? const Text(
                                    'Nenhuma meta programada no momento.',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: listaMetas.map((meta) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '• ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
