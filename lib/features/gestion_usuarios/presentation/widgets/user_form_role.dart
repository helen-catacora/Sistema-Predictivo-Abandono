// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'user_form_personal_info.dart';

/// Roles disponibles con su descripción recomendada.
const List<({int rolId, String rolName, String description, IconData icon})> _roles = [
  (
    rolId: 1,
    rolName: 'Super Administrador',
    description: 'Recomendado para el Jefe de Carrera',
    icon: Icons.admin_panel_settings_outlined,
  ),
  (
    rolId: 2,
    rolName: 'Administrador',
    description: 'Recomendado para el Coordinador de Ciencias Básicas',
    icon: Icons.manage_accounts_outlined,
  ),
  (
    rolId: 3,
    rolName: 'Encargado de Curso',
    description: 'Recomendado para el Encargado de Curso',
    icon: Icons.school_outlined,
  ),
];

/// Sección Rol y Permisos.
class UserFormRole extends StatelessWidget {
  const UserFormRole({
    super.key,
    required this.selectedRol,
    required this.estadoActivo,
    required this.onRolChanged,
    required this.onEstadoChanged,
    required this.selectedRolId,
    this.motivoInactivacion = '',
    this.onMotivoChanged,
  });

  final String selectedRol;
  final int selectedRolId;
  final bool estadoActivo;
  final ValueChanged<(String, int)> onRolChanged;
  final ValueChanged<bool> onEstadoChanged;
  final String motivoInactivacion;
  final ValueChanged<String>? onMotivoChanged;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FormSection(
      icon: Icons.settings_outlined,
      title: 'Rol y Permisos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccione el Rol del Usuario *',
            style: TextStyle(
              fontSize: Responsive.subtitleFontSize(screenWidth),
              fontWeight: FontWeight.w600,
              color: AppColors.grayDark,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = _roles
                  .map(
                    (r) => _RoleCard(
                      rol: r.rolName,
                      rolId: r.rolId,
                      description: r.description,
                      icon: r.icon,
                      isSelected:
                          selectedRol == r.rolName ||
                          selectedRolId == r.rolId,
                      onTap: () => onRolChanged((r.rolName, r.rolId)),
                    ),
                  )
                  .toList();

              if (constraints.maxWidth < 600) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      cards[i],
                    ],
                  ],
                );
              }

              return Row(
                children: cards
                    .map(
                      (card) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: card,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Estado Inicial',
            style: TextStyle(
              fontSize: Responsive.subtitleFontSize(screenWidth),
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
          if (!estadoActivo) ...[
            const SizedBox(height: 16),
            Text(
              'Motivo de Inactivación *',
              style: TextStyle(
                fontSize: Responsive.subtitleFontSize(screenWidth),
                fontWeight: FontWeight.w600,
                color: AppColors.grayDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: motivoInactivacion,
              onChanged: onMotivoChanged,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Especifique el motivo por el cual se inhabilita al usuario...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xffE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xffE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.navyMedium),
                ),
                filled: true,
                fillColor: Color(0xffF8FAFC),
                contentPadding: const EdgeInsets.all(12),
              ),
              validator: (value) {
                if (!estadoActivo && (value == null || value.trim().isEmpty)) {
                  return 'Debe especificar el motivo de inactivación';
                }
                return null;
              },
            ),
          ],
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
    required this.rolId,
    required this.description,
    required this.icon,
  });

  final String rol;
  final int rolId;
  final bool isSelected;
  final VoidCallback onTap;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.blueLight : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.navyMedium : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected
                        ? AppColors.navyMedium
                        : Colors.grey.shade400,
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rol,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isSelected
                            ? AppColors.navyMedium
                            : AppColors.grayDark,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.navyMedium,
                      size: 18,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.navyMedium.withValues(alpha: 0.08)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 12,
                      color: isSelected
                          ? AppColors.navyMedium
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? AppColors.navyMedium
                              : Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
