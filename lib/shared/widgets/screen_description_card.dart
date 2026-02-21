import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';

/// Tarjeta de descripción explicativa de una pantalla.
/// Fondo azul claro, texto azul/negro, diseño consistente en todas las pantallas (excepto login).
class ScreenDescriptionCard extends StatelessWidget {
  const ScreenDescriptionCard({
    super.key,
    required this.description,
    this.icon,
  });

  /// Texto explicativo de qué hace la pantalla.
  final String description;

  /// Icono opcional a la izquierda (por defecto info_outline).
  final IconData? icon;

  static const Color _cardBackground = Color(0xFFE8F4FD);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF1E3A5F);
  static const Color _borderColor = Color(0xFF93C5FD);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue1D4ED8.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon ?? Icons.info_outline_rounded,
              size: 22,
              color: _textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                description,
                style: GoogleFonts.inter(
                  color: _textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
