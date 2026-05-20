import 'package:flutter/material.dart';

import '../models/pratica.dart';

class PraticaCard extends StatelessWidget {
  final Pratica pratica;
  final VoidCallback onTap;
  final VoidCallback onFavoritoTap;

  const PraticaCard({
    super.key,
    required this.pratica,
    required this.onTap,
    required this.onFavoritoTap,
  });

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              offset: Offset(2, 4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icone,
                color: cor,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pratica.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pratica.categoria} • ${pratica.lembrete}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pratica.concluida ? 'Concluída' : 'Pendente',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: pratica.concluida
                          ? const Color(0xFF34A853)
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: onFavoritoTap,
              icon: Icon(
                pratica.favorita ? Icons.star : Icons.star_border,
                color: pratica.favorita ? Colors.amber : Colors.grey,
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}