import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'user_form_personal_info.dart';

/// Sección Credenciales de Acceso.
class UserFormCredentials extends StatefulWidget {
  const UserFormCredentials({
    super.key,
    required this.correoController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.isEditMode = false,
  });

  final TextEditingController correoController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isEditMode;

  @override
  State<UserFormCredentials> createState() => _UserFormCredentialsState();
}

class _UserFormCredentialsState extends State<UserFormCredentials> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      icon: Icons.key_outlined,
      title: 'Credenciales de Acceso',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.correoController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo Institucional *',
              hintText: 'usuario@emi.edu.bo',
              prefixIcon: const Icon(Icons.mail_outline),
              suffixIcon: Icon(
                Icons.info_outline,
                size: 18,
                color: Colors.grey.shade600,
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (v) {
              // if (v == null || v.trim().isEmpty) return 'Requerido';
              // if (!RegExp(r'^[\w\-\.]+@emi\.edu\.bo$').hasMatch(v.trim())) {
              //   return 'Debe ser correo institucional EMI';
              // }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  'Debe ser un correo institucional válido de EMI',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (!widget.isEditMode) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña *',
                hintText: 'Mínimo 8 caracteres',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: widget.isEditMode
                  ? null
                  : (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      if (v.length < 8) return 'Mínimo 8 caracteres';
                      if (!RegExp(r'[A-Z]').hasMatch(v)) {
                        return 'Al menos una mayúscula';
                      }
                      if (!RegExp(r'[a-z]').hasMatch(v)) {
                        return 'Al menos una minúscula';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(v)) {
                        return 'Al menos un número';
                      }
                      return null;
                    },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña *',
                hintText: 'Repita la contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: widget.isEditMode
                  ? null
                  : (v) {
                      if (v == null || v.isEmpty) return 'Requerido';
                      if (v != widget.passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentYellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.accentYellow.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requisitos de seguridad',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Mínimo 8 caracteres\n'
                          '• Al menos una letra mayúscula y una minúscula\n'
                          '• Al menos un número',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
