// widgets/meta_card.dart
import 'package:flutter/material.dart';
import '../models/meta.dart';

class MetaCard extends StatelessWidget {
  final Meta meta;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const MetaCard({
    super.key,
    required this.meta,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    // Convertendo pra porcentagem
    final int percentualInt = (meta.percentual * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), 
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meta.nome,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Barra de progresso customizada
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final double progressWidth = maxWidth * meta.percentual;

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Fundo da barra cinza
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Barra de progresso verde preenchida
                  Container(
                    width: progressWidth < 24 ? 24 : progressWidth,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF46C971),
                          Color(0xFF2A914D),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '$percentualInt%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso: ${meta.progressoDias} dias',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  // Botão de decrementar progresso
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDecrement,
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black45,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão de incrementar progresso
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onIncrement,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF46C971),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão de deletar meta
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}