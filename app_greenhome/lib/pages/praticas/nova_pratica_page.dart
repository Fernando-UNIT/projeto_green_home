import 'package:flutter/material.dart';
import '../../models/pratica.dart';
import '../../services/praticas_service.dart';
import 'package:flutter/services.dart';

class NovaPraticaPage extends StatefulWidget {
  final Pratica? pratica;

  const NovaPraticaPage({super.key, this.pratica});

  @override
  State<NovaPraticaPage> createState() => _NovaPraticaPageState();
}

class _NovaPraticaPageState extends State<NovaPraticaPage> {
  final nomeController = TextEditingController();
  final categoriaController = TextEditingController();
  final lembreteController = TextEditingController();
  final tempoController = TextEditingController();
  final descricaoController = TextEditingController();

  final praticasService = PraticasService();

  bool get editando => widget.pratica != null;

  // Unidade do tempo
  String unidadeSelecionada = 'minutos';
  final List<String> unidades = ['minutos', 'horas'];

  @override
  void initState() {
    super.initState();
    if (editando) {
      nomeController.text = widget.pratica!.nome;
      categoriaController.text = widget.pratica!.categoria;
      lembreteController.text = widget.pratica!.lembrete;
      tempoController.text = widget.pratica!.tempo.split(' ').first; // separa número
      unidadeSelecionada = widget.pratica!.tempo.contains('hora') ? 'horas' : 'minutos';
      descricaoController.text = widget.pratica!.descricao;
    }
  }

  void salvar() async {
    // Validação do nome
    if (nomeController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Digite o nome da prática.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Validação do tempo
    if (tempoController.text.trim().isEmpty || int.tryParse(tempoController.text.trim()) == null) {
            showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Digite um tempo válido em números.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final tempoFinal = '${tempoController.text.trim()} $unidadeSelecionada';

    final pratica = Pratica(
      id: editando
          ? widget.pratica!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nomeController.text.trim(),
      categoria: categoriaController.text.trim().isEmpty
          ? 'Sustentabilidade'
          : categoriaController.text.trim(),
      descricao: descricaoController.text.trim().isEmpty
          ? 'Sem descrição informada.'
          : descricaoController.text.trim(),
      lembrete: lembreteController.text.trim().isEmpty
          ? 'Sem lembrete'
          : lembreteController.text.trim(),
      tempo: tempoFinal,
      concluida: widget.pratica?.concluida ?? false,
      favorita: widget.pratica?.favorita ?? false,
    );

    if (editando) {
      await praticasService.atualizarPratica(pratica);
    } else {
      await praticasService.criarPratica(pratica);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nomeController.dispose();
    categoriaController.dispose();
    lembreteController.dispose();
    tempoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle visual
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Título
              Row(
                children: [
                  Expanded(
                    child: Text(
                      editando ? 'Editar Prática' : 'Nova Prática',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Campos do formulário
              _CampoTexto(
                label: 'Nome da Prática',
                hint: 'Ex: Separar lixo orgânico',
                controller: nomeController,
              ),
              const SizedBox(height: 14),
              _CampoTexto(
                label: 'Categoria',
                hint: 'Ex: Reciclagem, Energia, Consumo',
                controller: categoriaController,
              ),
              const SizedBox(height: 14),
              _CampoTexto(
                label: 'Lembrete',
                hint: 'Ex: Todo dia, 19:00h',
                controller: lembreteController,
              ),
              const SizedBox(height: 14),
              // Campo de tempo com dropdown de unidade
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _CampoTexto(
                      label: 'Tempo',
                      hint: 'Ex: 30',
                      controller: tempoController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: unidadeSelecionada,
                      items: unidades
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          unidadeSelecionada = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Unidade',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFF3F3F3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _CampoTexto(
                label: 'Descrição',
                hint: 'Descreva a prática sustentável',
                controller: descricaoController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              // Botão salvar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34A853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    editando ? 'Salvar alterações' : 'Criar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

class _CampoTexto extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  const _CampoTexto({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF3F3F3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}