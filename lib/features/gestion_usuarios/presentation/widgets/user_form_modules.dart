import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'user_form_personal_info.dart';

/// Módulos del sistema.
const List<Map<String, String>> _modulos = [
  {
    'id': 'Panel Principal',
    'title': 'Panel Principal',
    'desc': 'Acceso al dashboard principal del sistema',
    'icon': 'dashboard',
  },
  {
    'id': 'estudiantes',
    'title': 'Estudiantes',
    'desc': 'Gestión de estudiantes en riesgo',
    'icon': 'school',
  },
  {
    'id': 'asistencias',
    'title': 'Asistencia',
    'desc': 'Registro y control de asistencia',
    'icon': 'event_available',
  },
  {
    'id': 'Reportes',
    'title': 'Reportes',
    'desc': 'Generación y exportación de reportes',
    'icon': 'assessment',
  },
  {
    'id': 'Predicciones',
    'title': 'Predicciones',
    'desc': 'Visualización de predicciones de abandono',
    'icon': 'trending_up',
  },
  {
    'id': 'Gestión de Usuarios',
    'title': 'Gestión de Usuarios',
    'desc': 'Administración de usuarios del sistema',
    'icon': 'people',
  },
];

/// Sección Asignación de Módulos.
class UserFormModules extends StatelessWidget {
  const UserFormModules({
    super.key,
    required this.selectedModules,
    required this.onToggle,
  });

  final Set<String> selectedModules;
  final ValueChanged<String> onToggle;

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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _modulos
                .map(
                  (m) => _ModuleCard(
                    title: m['title']!,
                    description: m['desc']!,
                    icon: _iconFromName(m['icon']!),
                    isSelected: selectedModules.contains(m['id']),
                    onTap: () => onToggle(m['id']!),
                  ),
                )
                .toList(),
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
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'dashboard':
        return Icons.dashboard_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'event_available':
        return Icons.event_available_outlined;
      case 'assessment':
        return Icons.assessment_outlined;
      case 'trending_up':
        return Icons.trending_up_outlined;
      case 'people':
        return Icons.people_outline;
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
