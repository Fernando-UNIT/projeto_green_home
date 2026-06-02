// pages/metas/metas_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/meta.dart';
import '../../widgets/meta_card.dart';
import '../../controllers/metas_controller.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  final MetasController _metasController = MetasController();

  final _nomeController = TextEditingController();
  final _duracaoController = TextEditingController();

  String _categoriaSelecionada = 'Reciclagem';
  // Controla se o aviso de campo vazio deve ser exibido
  bool _nomeVazio = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  void _abrirModalNovaMeta() {
    _nomeVazio = false;
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
                          icon: const Icon(
                            Icons.close,
                            size: 28,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Nome da Meta'),
                    // Campo de nome com borda vermelha e mensagem de erro quando vazio
                    TextField(
                      controller: _nomeController,
                      onChanged: (_) {
                        if (_nomeVazio) {
                          setModalState(() => _nomeVazio = false);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Ex: Reciclar Plástico por 1 mês',
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        errorText: _nomeVazio ? 'Campo não pode ser vazio' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            // Borda vermelha quando o aviso está ativo
                            color: _nomeVazio
                                ? Colors.redAccent
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _nomeVazio
                                ? Colors.redAccent
                                : const Color(0xFF46C971),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Categoria'),
                              DropdownButtonFormField<String>(
                                initialValue: _categoriaSelecionada,
                                decoration: _inputDecorationBase(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black45,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Reciclagem',
                                    child: Text('Reciclagem'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Consumo',
                                    child: Text('Consumo'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Energia',
                                    child: Text('Energia'),
                                  ),
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

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Duração (dias)'),
                              // Apenas inteiros são aceitos no campo de duração
                              TextField(
                                controller: _duracaoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: _inputDecorationBase(hint: 'Ex: 30'),
                              ),
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
                          onPressed: () => _adicionarNovaMeta(setModalState),
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

void _adicionarNovaMeta(StateSetter setModalState) {
    if (_nomeController.text.trim().isEmpty) {
      setModalState(() => _nomeVazio = true);
      return;
    }

    final int totalDias = int.tryParse(_duracaoController.text.trim()) ?? 30;

    // Não precisamos mais dar setState, o StreamBuilder atualiza a tela sozinho
    _metasController.adicionar(
      _nomeController.text,
      _categoriaSelecionada,
      _duracaoController.text,
      totalDias,
    );

    _nomeController.clear();
    _duracaoController.clear();
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



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Minhas Metas',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
        Expanded(
          // StreamBuilder conecta diretamente com o Firestore e atualiza ao vivo
          child: StreamBuilder<List<Meta>>(
            stream: _metasController.metasStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF46C971)));
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar dados.', style: TextStyle(color: Colors.black45))
                );
              }

              final listaDeMetas = snapshot.data ?? [];

              if (listaDeMetas.isEmpty) {
                return const Center(
                  child: Text(
                    'Você ainda não possui metas registradas.',
                    style: TextStyle(color: Colors.black45),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: listaDeMetas.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final meta = listaDeMetas[index];
                  return MetaCard(
                    meta: meta,
                    // Ao invés do Index, passamos o ID do banco ou o próprio objeto
                    onDelete: () => _metasController.remover(meta.id),
                    onIncrement: () => _metasController.incrementar(meta),
                    onDecrement: () => _metasController.decrementar(meta),
                  );
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Nova Meta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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