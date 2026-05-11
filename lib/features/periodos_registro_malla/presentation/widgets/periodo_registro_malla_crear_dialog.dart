import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/periodos_registro_malla_provider.dart';

Future<void> showCrearPeriodoDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _CrearPeriodoDialog(),
  );
}

class _CrearPeriodoDialog extends StatefulWidget {
  const _CrearPeriodoDialog();

  @override
  State<_CrearPeriodoDialog> createState() => _CrearPeriodoDialogState();
}

class _CrearPeriodoDialogState extends State<_CrearPeriodoDialog> {
  final _fmt = DateFormat('dd/MM/yyyy');
  final _descController = TextEditingController();

  DateTime? _ini;
  DateTime? _fin;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(DateTime? initial, ValueChanged<DateTime> onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      locale: const Locale('es'),
    );
    if (picked != null) onPicked(picked);
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) {
    return InkWell(
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
          value != null ? _fmt.format(value) : 'Seleccionar fecha',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: value != null ? AppColors.black334155 : AppColors.gray9CA3AF,
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una descripción')),
      );
      return;
    }
    if (_ini == null || _fin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona ambas fechas')),
      );
      return;
    }
    if (!_fin!.isAfter(_ini!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha de fin debe ser posterior a la de inicio')),
      );
      return;
    }

    final ok = await context.read<PeriodosRegistroMallaProvider>().crearPeriodo(
          descripcion: desc,
          fechaInicio: _ini!,
          fechaFin: _fin!,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Período creado correctamente')),
      );
    } else {
      final msg = context.read<PeriodosRegistroMallaProvider>().errorMessage ?? 'Error al crear período';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<PeriodosRegistroMallaProvider>().isCreating;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.gray002855,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Nuevo período de importación de malla',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Ej. Plan Curricular 2024-2028',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  _dateField(
                    'Fecha de inicio',
                    _ini,
                    () => _pickDate(_ini, (d) => setState(() => _ini = d)),
                  ),
                  const SizedBox(height: 12),
                  _dateField(
                    'Fecha de fin',
                    _fin,
                    () => _pickDate(_fin, (d) => setState(() => _fin = d)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Solo puede haber un período activo a la vez. '
                    'El período nuevo se crea inactivo; actívalo cuando necesites habilitarlo.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey64748B),
                  ),
                ],
              ),
            ),
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
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Crear'),
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
