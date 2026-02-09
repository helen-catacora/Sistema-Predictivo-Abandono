import 'package:flutter/material.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';

/// Estado de asistencia del estudiante.
enum AttendanceStatus { presente, ausente, justificado }

/// Selector de estado de asistencia (Presente, Ausente, Justificado).
class AttendanceStatusSelector extends StatelessWidget {
  const AttendanceStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  final AttendanceStatus? selectedStatus;
  final ValueChanged<AttendanceStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusChip(
          label: 'Presente',
          icon: Icons.check,
          color: const Color(0xFF22C55E),
          isSelected: selectedStatus == AttendanceStatus.presente,
          onTap: () => onChanged(AttendanceStatus.presente),
        ),
        const SizedBox(width: 8),
        _StatusChip(
          label: 'Ausente',
          icon: Icons.close,
          color: const Color(0xFFEF4444),
          isSelected: selectedStatus == AttendanceStatus.ausente,
          onTap: () => onChanged(AttendanceStatus.ausente),
        ),
        const SizedBox(width: 8),
        _StatusChip(
          label: 'Justificado',
          icon: Icons.description_outlined,
          color: const Color(0xFF6B7280),
          isSelected: selectedStatus == AttendanceStatus.justificado,
          onTap: () => onChanged(AttendanceStatus.justificado),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? color.withValues(alpha: 0.2) : AppColors.greyF1F5F9,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? color : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : AppColors.darkBlue1E293B,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
