import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Datos del usuario para mostrar en el banner y secciones.
class MiPerfilUserData {
  const MiPerfilUserData({
    required this.nombreCompleto,
    required this.correo,
    required this.cargo,
    this.carnetIdentidad = '',
    this.telefono = '',
    this.rolSistema = 'Administrador del Sistema',
    this.enLinea = true,
  });

  final String nombreCompleto;
  final String correo;
  final String cargo;
  final String carnetIdentidad;
  final String telefono;
  final String rolSistema;
  final bool enLinea;
}

/// Banner oscuro con foto, nombre, rol y estado "En Línea".
class MiPerfilBanner extends StatelessWidget {
  const MiPerfilBanner({super.key, required this.userData});

  final MiPerfilUserData userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navyMedium,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            child: Text(
              _iniciales(userData.nombreCompleto),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.nombreCompleto,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: AppColors.accentYellow,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      userData.rolSistema,
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: userData.enLinea
                            ? AppColors.green16A34A
                            : AppColors.grayMedium,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userData.enLinea ? 'En Línea' : 'Desconectado',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return '${partes.first.substring(0, 1)}${partes.last.substring(0, 1)}'.toUpperCase();
  }
}
