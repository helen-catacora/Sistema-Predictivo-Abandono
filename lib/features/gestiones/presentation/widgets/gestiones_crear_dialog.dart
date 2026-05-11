import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/gestiones_provider.dart';

Future<void> showCrearGestionDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _CrearGestionDialog(),
  );
}

class _CrearGestionDialog extends StatefulWidget {
  const _CrearGestionDialog();

  @override
  State<_CrearGestionDialog> createState() => _CrearGestionDialogState();
}

class _CrearGestionDialogState extends State<_CrearGestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _fmt = DateFormat('dd/MM/yyyy');

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  DateTime? _iniRegistro;
  DateTime? _finRegistro;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(DateTime? initial, ValueChanged<DateTime> onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('es'),
    );
    if (picked != null) onPicked(picked);
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap, {bool required = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          value != null ? _fmt.format(value) : 'Seleccionar',
          style: GoogleFonts.inter(fontSize: 14, color: value != null ? AppColors.black334155 : AppColors.gray9CA3AF),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa las fechas del período académico')),
      );
      return;
    }
    if (!_fechaFin!.isAfter(_fechaInicio!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha de fin debe ser posterior a la de inicio')),
      );
      return;
    }
    if ((_iniRegistro == null) != (_finRegistro == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes configurar ambas fechas de registro o dejarlas vacías')),
      );
      return;
    }
    if (_iniRegistro != null && !_finRegistro!.isAfter(_iniRegistro!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha "Hasta" del registro debe ser posterior a "Desde"')),
      );
      return;
    }
    final ok = await context.read<GestionesProvider>().crearGestion(
          nombre: _nombreCtrl.text.trim(),
          fechaInicio: _fechaInicio!,
          fechaFin: _fechaFin!,
          fechaInicioRegistroEstudiantes: _iniRegistro,
          fechaFinRegistroEstudiantes: _finRegistro,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gestión creada correctamente')),
      );
    } else {
      final msg = context.read<GestionesProvider>().errorMessage ?? 'Error al crear gestión';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = context.watch<GestionesProvider>().isCreating;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
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
                  const Icon(Icons.add_circle_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Text('Nueva Gestión Académica',
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
            ),
            // Cuerpo
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nombre *',
                          hintText: 'Ej: I-2026',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Período académico'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _dateField('Inicio', _fechaInicio,
                              () => _pickDate(_fechaInicio, (d) => setState(() => _fechaInicio = d)), required: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _dateField('Fin', _fechaFin,
                              () => _pickDate(_fechaFin, (d) => setState(() => _fechaFin = d)), required: true)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _sectionTitle('Período de registro de estudiantes (opcional)'),
                      const SizedBox(height: 4),
                      Text(
                        'Limita cuándo se puede importar el Excel de estudiantes.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey64748B),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _dateField('Desde', _iniRegistro,
                              () => _pickDate(_iniRegistro, (d) => setState(() => _iniRegistro = d)))),
                          const SizedBox(width: 12),
                          Expanded(child: _dateField('Hasta', _finRegistro,
                              () => _pickDate(_finRegistro, (d) => setState(() => _finRegistro = d)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Botones
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isCreating ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.gray002855),
                      onPressed: isCreating ? null : _submit,
                      child: isCreating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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

  Widget _sectionTitle(String text) => Text(text,
      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.gray002855));
}
