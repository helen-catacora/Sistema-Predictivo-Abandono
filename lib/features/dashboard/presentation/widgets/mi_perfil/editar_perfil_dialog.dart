import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../auth/data/models/me_response.dart';

/// Diálogo para editar perfil (nombre, carnet_identidad, telefono, cargo).
/// Al guardar devuelve un [Map] con las claves del body PATCH /me.
class EditarPerfilDialog extends StatefulWidget {
  const EditarPerfilDialog({
    super.key,
    required this.me,
  });

  final MeResponse me;

  @override
  State<EditarPerfilDialog> createState() => _EditarPerfilDialogState();
}

class _EditarPerfilDialogState extends State<EditarPerfilDialog> {
  late TextEditingController _nombreController;
  late TextEditingController _carnetController;
  late TextEditingController _telefonoController;
  late TextEditingController _cargoController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.me.nombre);
    _carnetController = TextEditingController(text: widget.me.carnetIdentidad ?? '');
    _telefonoController = TextEditingController(text: widget.me.telefono ?? '');
    _cargoController = TextEditingController(text: widget.me.cargo ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _carnetController.dispose();
    _telefonoController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildBody() {
    return {
      'nombre': _nombreController.text.trim(),
      'carnet_identidad': _carnetController.text.trim(),
      'telefono': _telefonoController.text.trim(),
      'cargo': _cargoController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Perfil'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _carnetController,
                  decoration: const InputDecoration(
                    labelText: 'Carnet de identidad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cargoController,
                  decoration: const InputDecoration(
                    labelText: 'Cargo',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
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
              Navigator.of(context).pop(_buildBody());
            }
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.navyMedium),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
