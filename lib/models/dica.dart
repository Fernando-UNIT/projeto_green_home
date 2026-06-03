//dica.dart
import 'package:flutter/material.dart';

class Dica {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String text;

  bool favorito;

  Dica({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.text,
    this.favorito = false,
  });
}