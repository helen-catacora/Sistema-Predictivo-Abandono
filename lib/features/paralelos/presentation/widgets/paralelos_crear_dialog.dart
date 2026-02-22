import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/data/models/paralelo_item.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../../../gestion_usuarios/presentation/providers/usuarios_provider.dart';

/// Áreas fijas: 1=Tecnológicas, 2=No Tecnológicas.
const _areas = [(1, 'Tecnológicas'), (2, 'No Tecnológicas')];

/// Muestra el diálogo para crear un nuevo paralelo (POST /paralelos).
void showCrearParaleloDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => const _CrearParaleloDialog(),
  );
}

class _CrearParaleloDialog extends StatefulWidget {
  const _CrearParaleloDialog();

  @override
  State<_CrearParaleloDialog> createState() => _CrearParaleloDialogState();
}

class _CrearParaleloDialogState extends State<_CrearParaleloDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  String? _nombre;
  int? _areaId;
  int _semestreId = 0;
  int? _encargadoId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuariosProvider>().loadUsuarios();
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  /// Extrae semestreIds únicos de paralelos; si está vacío usa [1, 2].
  List<int> _semestreIdsFromParalelos(List<ParaleloItem> list) {
    final seen = <int>{};
    for (final p in list) {
      if (p.semestreId > 0) seen.add(p.semestreId);
    }
    final sorted = seen.toList()..sort();
    return sorted.isEmpty ? [1, 2] : sorted;
  }

  Future<void> _crear(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_nombre == null || _nombre!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese el nombre del paralelo')),
      );
      return;
    }
    if (_areaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un área')),
      );
      return;
    }
    if (_encargadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un encargado')),
      );
      return;
    }

    final provider = context.read<ParalelosProvider>();
    final ok = await provider.createParalelo(
      nombre: _nombre!.trim(),
      areaId: _areaId!,
      semestreId: _semestreId,
      encargadoId: _encargadoId!,
    );

    if (!context.mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Paralelo "${_nombre!.trim()}" creado correctamente'
              : provider.errorMessage ?? 'Error al crear paralelo',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ok ? AppColors.green16A34A : Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParalelosProvider, UsuariosProvider>(
      builder: (context, paralelosProvider, usuariosProvider, _) {
        final semestreIds = _semestreIdsFromParalelos(paralelosProvider.paralelos);
        final usuariosActivos = usuariosProvider.usuarios
            .where((u) => u.estado.toLowerCase() == 'activo')
            .toList();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Nuevo paralelo',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray002855,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Ej. 1-A, 2-B',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (v) => _nombre = v?.trim(),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _areaId,
                        decoration: const InputDecoration(
                          labelText: 'Área',
                          border: OutlineInputBorder(),
                        ),
                        items: _areas
                            .map((e) => DropdownMenuItem(
                                  value: e.$1,
                                  child: Text(e.$2),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _areaId = v),
                        onSaved: (v) => _areaId = v,
                        validator: (v) => v == null ? 'Seleccione un área' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int?>(
                        value: _semestreId == 0 ? null : _semestreId,
                        decoration: const InputDecoration(
                          labelText: 'Semestre (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('Sin semestre'),
                          ),
                          ...semestreIds.map(
                            (id) => DropdownMenuItem<int>(
                              value: id,
                              child: Text('Semestre $id'),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _semestreId = v ?? 0),
                        onSaved: (v) => _semestreId = v ?? 0,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _encargadoId,
                        decoration: const InputDecoration(
                          labelText: 'Encargado',
                          border: OutlineInputBorder(),
                        ),
                        items: usuariosActivos
                            .map((u) => DropdownMenuItem<int>(
                                  value: u.id,
                                  child: Text('${u.nombre} (${u.correo})'),
                                ))
                            .toList(),
                        onChanged: usuariosProvider.isLoading && usuariosActivos.isEmpty
                            ? null
                            : (v) => setState(() => _encargadoId = v),
                        onSaved: (v) => _encargadoId = v,
                        validator: (v) =>
                            v == null ? 'Seleccione un encargado' : null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.inter(
                                color: AppColors.grey64748B,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: paralelosProvider.isCreating
                                ? null
                                : () => _crear(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.green16A34A,
                            ),
                            child: paralelosProvider.isCreating
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Crear'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
