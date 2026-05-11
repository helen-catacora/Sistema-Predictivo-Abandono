import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/gestion_item.dart';
import '../providers/gestiones_provider.dart';

Future<void> showVentanaDialog(BuildContext context, GestionItem gestion) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _VentanaDialog(gestion: gestion),
  );
}

class _VentanaDialog extends StatefulWidget {
  const _VentanaDialog({required this.gestion});
  final GestionItem gestion;

  @override
  State<_VentanaDialog> createState() => _VentanaDialogState();
}

class _VentanaDialogState extends State<_VentanaDialog> {
  final _fmt = DateFormat('dd/MM/yyyy');

  late DateTime? _ini;
  late DateTime? _fin;

  @override
  void initState() {
    super.initState();
    _ini = widget.gestion.fechaInicioRegistroEstudiantes;
    _fin = widget.gestion.fechaFinRegistroEstudiantes;
  }

  Future<void> _pickDate(DateTime? initial, ValueChanged<DateTime?> onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('es'),
    );
    onPicked(picked);
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap, VoidCallback onClear) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              ),
              child: Text(
                value != null ? _fmt.format(value) : 'Sin configurar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: value != null ? AppColors.black334155 : AppColors.gray9CA3AF,
                ),
              ),
            ),
          ),
        ),
        if (value != null) ...[
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.clear, size: 18, color: AppColors.redDC2626),
            tooltip: 'Quitar fecha',
            onPressed: onClear,
          ),
        ],
      ],
    );
  }

  Future<void> _submit() async {
    if (_ini != null && _fin != null && !_fin!.isAfter(_ini!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha "Hasta" debe ser posterior a "Desde"')),
      );
      return;
    }
    final ok = await context.read<GestionesProvider>().updateVentana(
          id: widget.gestion.id,
          fechaInicioRegistroEstudiantes: _ini,
          fechaFinRegistroEstudiantes: _fin,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Período de registro actualizado')),
      );
    } else {
      final msg = context.read<GestionesProvider>().errorMessage ?? 'Error al actualizar';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<GestionesProvider>().isUpdatingVentana;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado navy
            Container(
              decoration: const BoxDecoration(
                color: AppColors.gray002855,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.event_available_outlined, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Período de registro de estudiantes',
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          widget.gestion.nombre,
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Cuerpo
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dateField(
                    'Desde',
                    _ini,
                    () => _pickDate(_ini, (d) { if (d != null) setState(() => _ini = d); }),
                    () => setState(() => _ini = null),
                  ),
                  const SizedBox(height: 12),
                  _dateField(
                    'Hasta',
                    _fin,
                    () => _pickDate(_fin, (d) { if (d != null) setState(() => _fin = d); }),
                    () => setState(() => _fin = null),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Si no configuras fechas, no habrá restricción de período.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey64748B),
                  ),
                ],
              ),
            ),
            // Botones
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSaving ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.green16A34A),
                      onPressed: isSaving ? null : _submit,
                      child: isSaving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
