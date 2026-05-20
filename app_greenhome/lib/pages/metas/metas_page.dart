//metas_page.dart
import 'package:flutter/material.dart';
import '../../models/meta.dart';
import '../../widgets/meta_card.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  final List<Meta> _metas = [];

  // Controladores que sobraram
  final _nomeController = TextEditingController();
  final _duracaoController = TextEditingController();

  // Categoria padrão que já vem selecionada no Dropdown
  String _categoriaSelecionada = 'Reciclagem';

  @override
  void dispose() {
    _nomeController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  void _abrirModalNovaMeta() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nova Meta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Nome da Meta'),
                    _buildTextField(_nomeController, 'Ex: Reciclar Plástico por 1 mês'),
                    const SizedBox(height: 16),

                    // Lado a Lado: Categoria e Tempo de Duração
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campo da Categoria (Dropdown)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Categoria'),
                              DropdownButtonFormField<String>(
                                initialValue: _categoriaSelecionada,
                                decoration: _inputDecorationBase(),
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                                items: const [
                                  DropdownMenuItem(value: 'Reciclagem', child: Text('Reciclagem')),
                                  DropdownMenuItem(value: 'Consumo', child: Text('Consumo')),
                                  DropdownMenuItem(value: 'Energia', child: Text('Energia')),
                                ],
                                onChanged: (novoValor) {
                                  setModalState(() {
                                    _categoriaSelecionada = novoValor!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Campo do Tempo de Duração
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tempo de Duração'),
                              _buildTextField(_duracaoController, 'Ex: 30 dias'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32), 

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF46C971), Color(0xFF2A914D)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: _adicionarNovaMeta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Criar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _adicionarNovaMeta() {
    if (_nomeController.text.trim().isEmpty) return;
    setState(() {
      _metas.add(
        Meta(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nome: _nomeController.text,
          categoria: _categoriaSelecionada, 
          duracao: _duracaoController.text,
        ),
      );
    });

    _nomeController.clear();
    _duracaoController.clear();
    // Reseta o dropdown para o padrão ao fechar
    _categoriaSelecionada = 'Reciclagem'; 

    Navigator.pop(context);
  }

  Widget _buildLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }
  InputDecoration _inputDecorationBase({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF46C971), width: 1.5),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: _inputDecorationBase(hint: hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Minhas Metas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),          ),
        ),
        Expanded(
          child: _metas.isEmpty
              ? const Center(
                  child: Text(
                    'Você ainda não possui metas registradas.',
                    style: TextStyle(color: Colors.black45),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _metas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final meta = _metas[index];
                    return MetaCard(
                      meta: meta,
                      onDelete: () {
                        setState(() {
                          _metas.removeAt(index);
                        });
                      },
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF46C971), Color(0xFF2A914D)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                onPressed: _abrirModalNovaMeta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Nova Meta',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}