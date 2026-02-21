import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_right_panel.dart';
import '../widgets/recaptcha_dialog.dart';

/// Pantalla de inicio de sesión del Sistema Predictivo de Abandono Estudiantil EMI.
/// Layout responsivo para web: dos columnas en desktop, una en móvil.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberSession = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = context.read<AuthProvider>();
      // No persistir sesión hasta pasar reCAPTCHA; así el redirect de GoRouter no cierra el diálogo
      final ok = await auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        recaptchaToken: null,
        persistSession: false,
      );
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Error al iniciar sesión'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        return;
      }
      final captchaOk = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const RecaptchaDialog(),
      );
      if (!mounted) return;
      if (captchaOk == true) {
        await auth.completeLogin();
        if (!mounted) return;
        context.go(AppRoutes.home);
      } else {
        await auth.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo validar la identidad con reCAPTCHA. Intente de nuevo.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (_, auth, _) => LoginRightPanel(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          obscurePassword: _obscurePassword,
          rememberSession: _rememberSession,
          isLoading: auth.isLoading,
          onTogglePassword: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          onToggleRemember: (v) =>
              setState(() => _rememberSession = v ?? false),
          onLogin: _onLogin,
        ),
      ),
    );
  }
}
