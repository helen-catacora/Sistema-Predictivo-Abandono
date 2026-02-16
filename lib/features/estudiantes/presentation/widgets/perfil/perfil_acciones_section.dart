import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/acciones_list_response.dart';
import 'perfil_section_card.dart';

/// Formato de fecha para la API (YYYY-MM-DD).
String _formatFechaApi(DateTime d) {
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// Diálogo para registrar una nueva acción (descripcion, fecha).
/// Devuelve (descripcion, fecha YYYY-MM-DD) o null si cancela.
Future<(String, String)?> _showNuevaAccionDialog(BuildContext context) async {
  final now = DateTime.now();
  return showDialog<(String, String)>(
    context: context,
    builder: (context) => _NuevaAccionDialog(initialFecha: now),
  );
}

class _NuevaAccionDialog extends StatefulWidget {
  const _NuevaAccionDialog({required this.initialFecha});

  final DateTime initialFecha;

  @override
  State<_NuevaAccionDialog> createState() => _NuevaAccionDialogState();
}

class _NuevaAccionDialogState extends State<_NuevaAccionDialog> {
  late TextEditingController _descripcionController;
  late TextEditingController _fechaController;
  DateTime _fecha = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fecha = widget.initialFecha;
    _descripcionController = TextEditingController();
    _fechaController = TextEditingController(text: _formatFechaApi(_fecha));
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() {
        _fecha = picked;
        _fechaController.text = _formatFechaApi(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Acción'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  hintText: 'Ej. Entrevista con psicopedagogía',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 2000,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha *',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                readOnly: true,
                onTap: _pickDate,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  final d = DateTime.tryParse(v.trim());
                  if (d == null) return 'Formato YYYY-MM-DD';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final desc = _descripcionController.text.trim();
              final fechaStr = _fechaController.text.trim();
              Navigator.of(context).pop((desc, fechaStr));
            }
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.navyMedium),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

/// Sección Acciones e Intervenciones del perfil.
/// Carga la lista desde GET /acciones?estudiante_id=&limite=50.
class PerfilAccionesSection extends StatefulWidget {
  const PerfilAccionesSection({
    super.key,
    required this.estudianteId,
    required this.loadAcciones,
    this.onCreateAccion,
    this.limite = 50,
  });

  final int estudianteId;
  /// Devuelve la lista de acciones (GET /acciones).
  final Future<List<AccionListItem>> Function() loadAcciones;
  /// Al crear una acción (descripcion, fecha). Si es null, el botón "Nueva Acción" no hace la petición.
  final Future<void> Function(String descripcion, String fecha)? onCreateAccion;
  final int limite;

  @override
  State<PerfilAccionesSection> createState() => _PerfilAccionesSectionState();
}

class _PerfilAccionesSectionState extends State<PerfilAccionesSection> {
  List<AccionListItem> _acciones = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAcciones();
  }

  Future<void> _loadAcciones() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await widget.loadAcciones();
      if (mounted) setState(() => _acciones = list);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onNuevaAccionPressed(BuildContext context) async {
    final onCreate = widget.onCreateAccion;
    if (onCreate == null) return;
    final result = await _showNuevaAccionDialog(context);
    if (result == null || !context.mounted) return;
    final (descripcion, fecha) = result;
    try {
      await onCreate(descripcion, fecha);
      await _loadAcciones();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Acción registrada correctamente'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PerfilSectionCard(
      icon: Icons.assignment_outlined,
      title: 'Acciones e Intervenciones',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: widget.onCreateAccion == null
                      ? null
                      : () => _onNuevaAccionPressed(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nueva Acción'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: AppColors.grayDark,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                ),
              )
            else if (_acciones.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No hay acciones registradas',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              )
            else
              ..._acciones.take(widget.limite).map((a) => _AccionListTile(accion: a)),
          ],
        ),
      ),
    );
  }
}

class _AccionListTile extends StatelessWidget {
  const _AccionListTile({required this.accion});

  final AccionListItem accion;

  @override
  Widget build(BuildContext context) {
    final desc = accion.descripcion;
    final titulo = desc.length > 60 ? '${desc.substring(0, 60)}...' : desc;
    final fecha = accion.fecha;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.isEmpty ? 'Acción #${accion.id}' : titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              desc,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                _formatFecha(fecha),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatFecha(String iso) {
    if (iso == '-') return iso;
    try {
      final d = DateTime.tryParse(iso);
      if (d == null) return iso;
      final now = DateTime.now();
      final diff = now.difference(d);
      if (diff.inDays == 0) return 'Hoy, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
      if (diff.inDays == 1) return 'Ayer';
      if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
      if (diff.inDays < 30) return 'Hace ${(diff.inDays / 7).floor()} semana(s)';
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso;
    }
  }
}
