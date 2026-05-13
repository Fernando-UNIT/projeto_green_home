import 'package:flutter/material.dart';
class DicasPage extends StatelessWidget {
  const DicasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Dicas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: const [
              DicaCard(
                icon: Icons.water_drop_outlined,
                iconColor: Color(0XFF0088FF),
                iconBgColor: Color(0xFFD0E9FF),
                text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mi lorem, condimentum tristique suscipit vel, commodo quis lorem.',
              ),
              SizedBox(height: 16),
              DicaCard(
                icon: Icons.lightbulb_outline,
                iconColor: Color(0XFFFFCC00),
                iconBgColor: Color(0xFFFFF4C8),
                text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mi lorem, condimentum tristique suscipit vel, commodo quis lorem.',
              ),
              SizedBox(height: 16),
              DicaCard(
                icon: Icons.recycling,
                iconColor: Color(0xFF15B800),
                iconBgColor: Color(0xFFDBFDD6),
                text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mi lorem, condimentum tristique suscipit vel, commodo quis lorem.',
              ),
              SizedBox(height: 32), 
            ],
          ),
        ),
      ],
    );
  }
}
//Widget para o cartão de dica
class DicaCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String text;

  const DicaCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.text,
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
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: iconColor,
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
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600, 
                  color: Color(0xFF666666), 
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}