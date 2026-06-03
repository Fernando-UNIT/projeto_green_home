import 'package:flutter/material.dart';
import '../../models/pratica.dart';

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

  bool get editando => widget.pratica != null;

  @override
  void initState() {
    super.initState();
    if (editando) {
      nomeController.text = widget.pratica!.nome;
      categoriaController.text = widget.pratica!.categoria;
      lembreteController.text = widget.pratica!.lembrete;
      tempoController.text = widget.pratica!.tempo;
      descricaoController.text = widget.pratica!.descricao;
    }
  }

  void salvar() {
    if (nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome da prática.')),
      );
      return;
    }

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
      tempo: tempoController.text.trim().isEmpty
          ? 'Não informado'
          : tempoController.text.trim(),
      concluida: widget.pratica?.concluida ?? false,
      favorita: widget.pratica?.favorita ?? false,
    );

    Navigator.pop(context, pratica);
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
              _CampoTexto(
                label: 'Tempo',
                hint: 'Ex: 10 min',
                controller: tempoController,
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