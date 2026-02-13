import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Diálogo para cambiar contraseña (actual y nueva).
/// Al guardar devuelve el record (contrasenaActual, contrasenaNueva).
class CambiarContrasenaDialog extends StatefulWidget {
  const CambiarContrasenaDialog({super.key});

  @override
  State<CambiarContrasenaDialog> createState() => _CambiarContrasenaDialogState();
}

class _CambiarContrasenaDialogState extends State<CambiarContrasenaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _actualController;
  late TextEditingController _nuevaController;
  late TextEditingController _confirmarController;
  bool _obscureActual = true;
  bool _obscureNueva = true;
  bool _obscureConfirmar = true;

  @override
  void initState() {
    super.initState();
    _actualController = TextEditingController();
    _nuevaController = TextEditingController();
    _confirmarController = TextEditingController();
  }

  @override
  void dispose() {
    _actualController.dispose();
    _nuevaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar contraseña'),
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
                  controller: _actualController,
                  obscureText: _obscureActual,
                  decoration: InputDecoration(
                    labelText: 'Contraseña actual *',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureActual ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscureActual = !_obscureActual),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nuevaController,
                  obscureText: _obscureNueva,
                  decoration: InputDecoration(
                    labelText: 'Contraseña nueva *',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNueva ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscureNueva = !_obscureNueva),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarController,
                  obscureText: _obscureConfirmar,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña nueva *',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmar
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                          () => _obscureConfirmar = !_obscureConfirmar),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (v != _nuevaController.text) {
                      return 'No coincide con la contraseña nueva';
                    }
                    return null;
                  },
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
              Navigator.of(context).pop((
                _actualController.text.trim(),
                _nuevaController.text.trim(),
              ));
            }
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.navyMedium),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
