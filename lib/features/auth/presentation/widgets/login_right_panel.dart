import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Panel derecho del login con el formulario de inicio de sesión.
class LoginRightPanel extends StatelessWidget {
  const LoginRightPanel({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberSession,
    this.isLoading = false,
    required this.onTogglePassword,
    required this.onToggleRemember,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberSession;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final ValueChanged<bool?> onToggleRemember;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        image: DecorationImage(
          image: AssetImage('assets/fondo-emi.png'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Center(
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.9,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: Image.network(
                                'https://tse1.mm.bing.net/th/id/OIP.rWIa57aBTxT20Yxk3PFouAHaHa?cb=defcache2defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // child: Container(
                      //   width: 80,
                      //   height: 80,
                      //   decoration: BoxDecoration(
                      //     color: AppColors.gray002855.withValues(alpha: 0.1),
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      //   child: Icon(
                      //     FontAwesomeIcons.lock,
                      //     size: 30,
                      //     color: AppColors.gray002855,
                      //   ),
                      // ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Bienvenido al Sistema Predictivo de Abandono Estudiantil de ',

                        style: GoogleFonts.inter(
                          color: AppColors.darkBlue1E293B,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          height: 45 / 36,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(
                            text: 'Ciencias Basicas',

                            style: GoogleFonts.inter(
                              color: AppColors.yellowFFD60A,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              height: 45 / 36,
                              letterSpacing: 0,
                              shadows: [
                                // Estas sombras crean el efecto de borde azul
                                Shadow(
                                  offset: Offset(-1.5, -1.5),
                                  color: Color(0xff214d99),
                                ),
                                Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Color(0xff214d99),
                                ),
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  color: Color(0xff214d99),
                                ),
                                Shadow(
                                  offset: Offset(-1.5, 1.5),
                                  color: Color(0xff214d99),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingrese sus credenciales para acceder al sistema',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Color(0xff64748B),
                        fontSize: 16,
                        height: 24 / 16,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16,
                          color: AppColors.gray002855,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CORREO ELECTRÓNICO',
                          style: GoogleFonts.inter(
                            color: Color(0xff334155),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 20 / 14,
                            letterSpacing: 0.35,
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
                        Icon(
                          FontAwesomeIcons.key,
                          size: 16,
                          color: AppColors.gray002855,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CONTRASEÑA',
                          style: GoogleFonts.inter(
                            color: Color(0xff334155),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 20 / 14,
                            letterSpacing: 0.35,
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
                          icon: Icon(
                            FontAwesomeIcons.solidEye,
                            color: Color(0xff94A3B8),
                            size: 18,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: isLoading ? null : onLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: Color(0xff001233),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else
                              Text(
                                'INICIAR SESIÓN',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 24 / 16,
                                  letterSpacing: 0,
                                ),
                              ),
                            if (!isLoading) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
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
                          Icon(Icons.info, color: Color(0xff001233)),
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
                    // Text.rich(
                    //   TextSpan(
                    //     text: '¿Necesita ayuda? ',
                    //     style: TextStyle(color: AppColors.grayDark, fontSize: 14),
                    //     children: [
                    //       TextSpan(
                    //         text: 'Contacte a Soporte Técnico',
                    //         style: const TextStyle(
                    //           color: AppColors.navyMedium,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
