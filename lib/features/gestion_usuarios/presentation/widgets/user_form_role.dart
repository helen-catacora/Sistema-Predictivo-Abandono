import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'user_form_personal_info.dart';

/// Roles disponibles.
const List<String> _roles = [
  'JEFE DE CARRERA',
  'DOCENTE A DEDICACIÓN EXCLUSIVA',
  'ENCARGADO DE CURSO',
];

/// Sección Rol y Permisos.
class UserFormRole extends StatelessWidget {
  const UserFormRole({
    super.key,
    required this.selectedRol,
    required this.estadoActivo,
    required this.onRolChanged,
    required this.onEstadoChanged,
  });

  final String selectedRol;
  final bool estadoActivo;
  final ValueChanged<String> onRolChanged;
  final ValueChanged<bool> onEstadoChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      icon: Icons.settings_outlined,
      title: 'Rol y Permisos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccione el Rol del Usuario *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grayDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _roles
                .map(
                  (r) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _RoleCard(
                        rol: r,
                        isSelected: selectedRol == r,
                        onTap: () => onRolChanged(r),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Estado Inicial',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grayDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: estadoActivo,
                onChanged: (v) => onEstadoChanged(true),
                activeColor: AppColors.navyMedium,
              ),
              const SizedBox(width: 4),
              const Text('Activo'),
              const SizedBox(width: 24),
              Radio<bool>(
                value: false,
                groupValue: estadoActivo,
                onChanged: (v) => onEstadoChanged(false),
                activeColor: AppColors.navyMedium,
              ),
              const SizedBox(width: 4),
              const Text('Inactivo'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.rol,
    required this.isSelected,
    required this.onTap,
  });

  final String rol;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final usePurple = rol == 'DOCENTE A DEDICACIÓN EXCLUSIVA';
    return Material(
        color: isSelected
            ? (usePurple
                ? Colors.purple.shade100
                : AppColors.blueLight)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (usePurple ? Colors.purple : AppColors.navyMedium)
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isSelected
                      ? (usePurple ? Colors.purple : AppColors.navyMedium)
                      : Colors.grey.shade400,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rol,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: isSelected
                          ? AppColors.navyMedium
                          : AppColors.grayDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
