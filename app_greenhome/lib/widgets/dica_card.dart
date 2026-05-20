//dicas_card.dart
import 'package:flutter/material.dart';

import '../models/dica.dart';

class DicaCard extends StatelessWidget {
  final Dica dica;
  final VoidCallback onFavoritoPressed;

  const DicaCard({
    super.key,
    required this.dica,
    required this.onFavoritoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(2, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: dica.iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              dica.icon,
              color: dica.iconColor,
              size: 48,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dica.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: onFavoritoPressed,
                    icon: Icon(
                      dica.favorito
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}