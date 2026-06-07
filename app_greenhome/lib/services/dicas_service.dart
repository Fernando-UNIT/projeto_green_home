// services/dicas_service.dart
import 'package:flutter/material.dart';

import '../models/dica.dart';

class DicasService {
  static List<Dica> getDicas() {
    return [
      Dica(
        id: 'agua_1',
        icon: Icons.water_drop_outlined,
        iconColor: const Color(0xFF0088FF),
        iconBgColor: const Color(0xFFD0E9FF),
        text: 'Feche a torneira enquanto escova os dentes. Isso economiza até 12 litros de água por uso.',
      ),
      Dica(
        id: 'agua_2',
        icon: Icons.water_drop_outlined,
        iconColor: const Color(0xFF0088FF),
        iconBgColor: const Color(0xFFD0E9FF),
        text: 'Reduza o tempo no chuveiro. Um banho de 5 minutos consome cerca de 45 litros, contra 135 de um banho longo.',
      ),
      Dica(
        id: 'agua_3',
        icon: Icons.water_drop_outlined,
        iconColor: const Color(0xFF0088FF),
        iconBgColor: const Color(0xFFD0E9FF),
        text: 'Aproveite a água da máquina de lavar para limpar o quintal ou lavar o carro.',
      ),
      Dica(
        id: 'energia_1',
        icon: Icons.lightbulb_outline,
        iconColor: const Color(0xFFFFCC00),
        iconBgColor: const Color(0xFFFFF4C8),
        text: 'Aproveite a luz natural abrindo janelas e cortinas durante o dia, reduzindo o uso de lâmpadas.',
      ),
      Dica(
        id: 'energia_2',
        icon: Icons.lightbulb_outline,
        iconColor: const Color(0xFFFFCC00),
        iconBgColor: const Color(0xFFFFF4C8),
        text: 'Tire os aparelhos da tomada em modo "stand-by" quando viajar. Eles continuam consumindo energia silenciosamente.',
      ),
      Dica(
        id: 'energia_3',
        icon: Icons.lightbulb_outline,
        iconColor: const Color(0xFFFFCC00),
        iconBgColor: const Color(0xFFFFF4C8),
        text: 'Troque lâmpadas incandescentes por LED. Elas duram mais e consomem até 80% menos energia.',
      ),
      Dica(
        id: 'reciclagem_1',
        icon: Icons.recycling,
        iconColor: const Color(0xFF15B800),
        iconBgColor: const Color(0xFFDBFDD6),
        text: 'Lave as embalagens plásticas e de vidro antes de descartar para evitar mau cheiro e proliferação de insetos.',
      ),
      Dica(
        id: 'reciclagem_2',
        icon: Icons.recycling,
        iconColor: const Color(0xFF15B800),
        iconBgColor: const Color(0xFFDBFDD6),
        text: 'Separe o lixo orgânico (restos de comida) do lixo reciclável (papel, plástico, vidro e metal).',
      ),
      Dica(
        id: 'reciclagem_3',
        icon: Icons.recycling,
        iconColor: const Color(0xFF15B800),
        iconBgColor: const Color(0xFFDBFDD6),
        text: 'Nunca descarte pilhas e baterias no lixo comum. Leve-as a postos de coleta específicos para evitar contaminação.',
      ),
    ];
  }
}