import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
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

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: integrar con AuthProvider y validar credenciales
      context.go(AppRoutes.home);
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
                        child: LoginRightPanel(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          rememberSession: _rememberSession,
                          onTogglePassword: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                          onToggleRemember: (v) =>
                              setState(() => _rememberSession = v ?? false),
                          onLogin: _onLogin,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        LoginLeftPanel(compact: true),
                        LoginRightPanel(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          rememberSession: _rememberSession,
                          onTogglePassword: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          onToggleRemember: (v) =>
                              setState(() => _rememberSession = v ?? false),
                          onLogin: _onLogin,
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
