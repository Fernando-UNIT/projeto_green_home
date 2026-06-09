import 'package:flutter/material.dart';
import '../../models/pratica.dart';
import 'nova_pratica_page.dart';
import '../../services/praticas_service.dart';

class DetalhePraticaPage extends StatefulWidget {
  final Pratica pratica;

  const DetalhePraticaPage({super.key, required this.pratica});

  @override
  State<DetalhePraticaPage> createState() => _DetalhePraticaPageState();
}

class _DetalhePraticaPageState extends State<DetalhePraticaPage> {
  late Pratica pratica;
  final praticasService = PraticasService();

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
    final praticaAtualizada = await showModalBottomSheet<Pratica>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NovaPraticaPage(pratica: pratica),
    );

    if (praticaAtualizada != null) {
      await praticasService.atualizarPratica(praticaAtualizada);
      setState(() {
        pratica = praticaAtualizada;
      });
    }
  }

  void excluirPratica() async {
    await praticasService.excluirPratica(pratica);
    Navigator.pop(context);
  }

  void alternarConclusao() async {
    pratica.concluida = !pratica.concluida;
    await praticasService.atualizarPratica(pratica);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: cor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icone, color: cor, size: 38),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                pratica.nome,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              pratica.favorita ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                        Text(
                          pratica.categoria,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Detalhes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _LinhaDetalhe(titulo: 'Descrição', valor: pratica.descricao),
                    const Divider(),
                    _LinhaDetalhe(titulo: 'Lembrete', valor: pratica.lembrete),
                    const Divider(),
                    _LinhaDetalhe(titulo: 'Tempo', valor: pratica.tempo),
                    const Divider(),
                    _LinhaDetalhe(
                      titulo: 'Estado Atual',
                      valor: pratica.concluida ? 'Concluída' : 'Pendente',
                      corValor: pratica.concluida ? const Color(0xFF34A853) : Colors.amber,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Botões
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: excluirPratica,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: alternarConclusao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34A853),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          pratica.concluida ? 'Pendente' : 'Concluir',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Botão editar prática
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: editarPratica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Editar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe _LinhaDetalhe no nível do arquivo
class _LinhaDetalhe extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color? corValor;

  const _LinhaDetalhe({
    Key? key,
    required this.titulo,
    required this.valor,
    this.corValor,
  }) : super(key: key);

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