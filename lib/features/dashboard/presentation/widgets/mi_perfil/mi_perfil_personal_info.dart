import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'mi_perfil_banner.dart';

/// Sección "Información Personal" con campos en dos columnas y botón Editar Perfil.
class MiPerfilPersonalInfo extends StatelessWidget {
  const MiPerfilPersonalInfo({
    super.key,
    required this.userData,
    this.onEditarPerfil,
  });

  final MiPerfilUserData userData;
  final VoidCallback? onEditarPerfil;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Información Personal',
              style: TextStyle(
                color: AppColors.navyMedium,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: onEditarPerfil ?? () {},
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Editar Perfil'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navyMedium,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final useRow = constraints.maxWidth > 700;
            if (useRow) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildLeftColumn()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildRightColumn()),
                ],
              );
            }
            return Column(
              children: [
                _buildLeftColumn(),
                const SizedBox(height: 16),
                _buildRightColumn(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldBox(
          label: 'NOMBRE COMPLETO',
          value: userData.nombreCompleto,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _FieldBox(
          label: 'CORREO ELECTRÓNICO',
          value: userData.correo,
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        _FieldBox(
          label: 'CARGO',
          value: userData.cargo,
          icon: Icons.work_outline,
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldBox(
          label: 'CARNET DE IDENTIDAD',
          value: userData.carnetIdentidad.isEmpty ? '-' : userData.carnetIdentidad,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        _FieldBox(
          label: 'TELÉFONO',
          value: userData.telefono.isEmpty ? '-' : userData.telefono,
          icon: Icons.phone_outlined,
        ),
        const SizedBox(height: 16),
        _RoleField(rol: userData.rolSistema),
      ],
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grayDark,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.greyF1F5F9,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyE2E8F0),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.blue1D4ED8),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.black0F172A,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoleField extends StatelessWidget {
  const _RoleField({required this.rol});

  final String rol;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ROL DEL SISTEMA',
          style: TextStyle(
            color: AppColors.grayDark,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.greyF1F5F9,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyE2E8F0),
          ),
          child: Row(
            children: [
              Icon(Icons.shield_outlined, size: 20, color: AppColors.accentYellow),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.navyMedium,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rol.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
