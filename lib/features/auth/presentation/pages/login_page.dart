import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_left_panel.dart';
import '../widgets/login_right_panel.dart';

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = context.read<AuthProvider>();
      final ok = await auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (ok) {
        context.go(AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Error al iniciar sesión'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: LoginLeftPanel(),
                      ),
                      Expanded(
                        flex: 1,
                        child:                         Consumer<AuthProvider>(
                          builder: (_, auth, __) => LoginRightPanel(
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
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        LoginLeftPanel(compact: true),
                        Consumer<AuthProvider>(
                          builder: (_, auth, __) => LoginRightPanel(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            rememberSession: _rememberSession,
                            isLoading: auth.isLoading,
                            onTogglePassword: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            onToggleRemember: (v) =>
                                setState(() => _rememberSession = v ?? false),
                            onLogin: _onLogin,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          LoginFooter(),
        ],
      ),
    );
  }
}
