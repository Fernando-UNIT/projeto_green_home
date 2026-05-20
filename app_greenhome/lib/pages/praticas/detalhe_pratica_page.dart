import 'package:flutter/material.dart';

import '../../models/pratica.dart';
import 'nova_pratica_page.dart';

class DetalhePraticaPage extends StatefulWidget {
  final Pratica pratica;
  final VoidCallback onExcluir;
  final VoidCallback onAlternarConclusao;
  final Function(Pratica praticaAtualizada) onEditar;

  const DetalhePraticaPage({
    super.key,
    required this.pratica,
    required this.onExcluir,
    required this.onAlternarConclusao,
    required this.onEditar,
  });

  @override
  State<DetalhePraticaPage> createState() => _DetalhePraticaPageState();
}

class _DetalhePraticaPageState extends State<DetalhePraticaPage> {
  late Pratica pratica;

  @override
  void initState() {
    super.initState();
    pratica = widget.pratica;
  }

  IconData get icone {
    switch (pratica.categoria.toLowerCase()) {
      case 'reciclagem':
        return Icons.recycling;
      case 'energia':
        return Icons.lightbulb_outline;
      case 'consumo':
      case 'água':
      case 'agua':
        return Icons.water_drop_outlined;
      default:
        return Icons.eco_outlined;
    }
  }

  Color get cor {
    switch (pratica.categoria.toLowerCase()) {
      case 'reciclagem':
        return const Color(0xFF34A853);
      case 'energia':
        return const Color(0xFFFFC107);
      case 'consumo':
      case 'água':
      case 'agua':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF34A853);
    }
  }

  Future<void> editarPratica() async {
    final praticaAtualizada = await Navigator.push<Pratica>(
      context,
      MaterialPageRoute(
        builder: (_) => NovaPraticaPage(
          pratica: pratica,
        ),
      ),
    );

    if (praticaAtualizada != null) {
      widget.onEditar(praticaAtualizada);

      setState(() {
        pratica = praticaAtualizada;
      });
    }
  }

  void excluirPratica() {
    widget.onExcluir();
    Navigator.pop(context);
  }

  void alternarConclusao() {
    widget.onAlternarConclusao();

    setState(() {
      pratica.concluida = !pratica.concluida;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        title: const Text('Detalhes da Prática'),
        backgroundColor: const Color(0xFF34A853),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: editarPratica,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(2, 4),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: cor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          icone,
                          color: cor,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pratica.nome,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pratica.categoria,
                              style: const TextStyle(
                                color: Color(0xFF777777),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        pratica.favorita ? Icons.star : Icons.star_border,
                        color: pratica.favorita ? Colors.amber : Colors.grey,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _LinhaDetalhe(
                    titulo: 'Descrição',
                    valor: pratica.descricao,
                  ),
                  const Divider(height: 28),

                  _LinhaDetalhe(
                    titulo: 'Lembrete',
                    valor: pratica.lembrete,
                  ),
                  const Divider(height: 28),

                  _LinhaDetalhe(
                    titulo: 'Tempo',
                    valor: pratica.tempo,
                  ),
                  const Divider(height: 28),

                  _LinhaDetalhe(
                    titulo: 'Estado atual',
                    valor: pratica.concluida ? 'Concluída' : 'Pendente',
                    corValor:
                        pratica.concluida ? const Color(0xFF34A853) : Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: alternarConclusao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pratica.concluida
                      ? Colors.orange
                      : const Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  pratica.concluida
                      ? 'Pendente'
                      : 'Concluir',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: excluirPratica,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Excluir prática',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaDetalhe extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color? corValor;

  const _LinhaDetalhe({
    required this.titulo,
    required this.valor,
    this.corValor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$titulo:',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: corValor ?? Colors.black87,
              fontWeight: corValor == null ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}