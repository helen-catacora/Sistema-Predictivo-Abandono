import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'image_placeholder.dart';

/// Panel derecho del login con el formulario de inicio de sesión.
class LoginRightPanel extends StatelessWidget {
  const LoginRightPanel({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberSession,
    required this.onTogglePassword,
    required this.onToggleRemember,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberSession;
  final VoidCallback onTogglePassword;
  final ValueChanged<bool?> onToggleRemember;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.grayLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const ImagePlaceholder(size: 48, borderRadius: 8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Bienvenido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.navyMedium,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingrese sus credenciales para acceder al sistema',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grayMedium,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const ImagePlaceholder(size: 20, borderRadius: 4),
                      const SizedBox(width: 8),
                      Text(
                        'CORREO ELECTRÓNICO',
                        style: TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'usuario@emi.edu.bo',
                      suffixText: '@',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingrese su correo';
                      if (!v.contains('@')) return 'Correo inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const ImagePlaceholder(size: 20, borderRadius: 4),
                      const SizedBox(width: 8),
                      Text(
                        'CONTRASEÑA',
                        style: TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: '**********',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        onPressed: onTogglePassword,
                        icon: const ImagePlaceholder(
                          size: 24,
                          borderRadius: 4,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingrese su contraseña';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: rememberSession,
                          onChanged: onToggleRemember,
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.navyMedium;
                            }
                            return null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recordar sesión',
                        style: TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // TODO: ¿Olvidó su contraseña?
                        },
                        child: const Text(
                          '¿Olvidó su contraseña?',
                          style: TextStyle(
                            color: AppColors.navyMedium,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: onLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navyMedium,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('INICIAR SESIÓN'),
                        const SizedBox(width: 8),
                        const ImagePlaceholder(size: 20, borderRadius: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blueLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ImagePlaceholder(size: 24, borderRadius: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Acceso Restringido',
                                style: TextStyle(
                                  color: AppColors.navyMedium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Este sistema es de uso exclusivo para personal '
                                'autorizado de la EMI. El acceso no autorizado '
                                'está prohibido y será monitoreado.',
                                style: TextStyle(
                                  color: AppColors.grayDark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: '¿Necesita ayuda? ',
                      style: TextStyle(
                        color: AppColors.grayDark,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Contacte a Soporte Técnico',
                          style: const TextStyle(
                            color: AppColors.navyMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
