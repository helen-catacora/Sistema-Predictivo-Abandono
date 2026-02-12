import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'user_form_personal_info.dart';

/// Sección Asignación de Módulos.
/// Recibe la lista de módulos desde la BD y el set de módulos seleccionados (por nombre).
class UserFormModules extends StatelessWidget {
  const UserFormModules({
    super.key,
    required this.modulos,
    required this.selectedModules,
    required this.onToggle,
    this.isLoading = false,
  });

  /// Lista de módulos del sistema [{id: int, nombre: String}].
  final List<Map<String, dynamic>> modulos;
  final Set<int> selectedModules;
  final ValueChanged<int> onToggle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      icon: Icons.apps_outlined,
      title: 'Asignación de Módulos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccione los módulos del sistema a los que tendrá acceso este usuario',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grayDark,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: modulos.map((m) {
                final id = (m['id'] as num).toInt();
                final nombre = m['nombre'] as String;
                return _ModuleCard(
                  title: nombre,
                  description: _descripcionModulo(nombre),
                  icon: _iconFromModulo(nombre),
                  isSelected: selectedModules.contains(id),
                  onTap: () => onToggle(id),
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blueLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.blueLight),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.navyMedium),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Los módulos seleccionados determinan las secciones del sistema a las que el usuario podrá acceder.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.navyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _descripcionModulo(String nombre) {
    switch (nombre) {
      case 'Gestión de Usuarios':
        return 'Administración de usuarios del sistema';
      case 'Gestión de Datos de Estudiantes':
        return 'Gestión de estudiantes y sus datos';
      case 'Visualización de Resultados':
        return 'Dashboard y predicciones de abandono';
      case 'Control de Asistencia':
        return 'Registro y control de asistencia';
      case 'Reportes':
        return 'Generación y exportación de reportes';
      default:
        return nombre;
    }
  }

  IconData _iconFromModulo(String nombre) {
    switch (nombre) {
      case 'Gestión de Usuarios':
        return Icons.people_outline;
      case 'Gestión de Datos de Estudiantes':
        return Icons.school_outlined;
      case 'Visualización de Resultados':
        return Icons.trending_up_outlined;
      case 'Control de Asistencia':
        return Icons.event_available_outlined;
      case 'Reportes':
        return Icons.assessment_outlined;
      default:
        return Icons.apps_outlined;
    }
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Material(
        color: isSelected ? AppColors.blueLight : Colors.grey.shade50,
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
                    ? AppColors.navyMedium
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: AppColors.navyMedium,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 20, color: AppColors.navyMedium),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
