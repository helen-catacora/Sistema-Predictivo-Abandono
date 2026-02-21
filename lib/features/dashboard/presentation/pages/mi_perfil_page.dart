import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/models/me_response.dart';
import '../../../auth/repositories/auth_repository.dart';
import '../widgets/mi_perfil/cambiar_contrasena_dialog.dart';
import '../widgets/mi_perfil/editar_perfil_dialog.dart';
import '../widgets/mi_perfil/mi_perfil_account_config.dart';
import '../widgets/mi_perfil/mi_perfil_banner.dart';
import '../widgets/mi_perfil/mi_perfil_personal_info.dart';

/// Página "Mi Perfil" del usuario en sesión.
/// Carga los datos con GET /me y los muestra en banner e información personal.
class MiPerfilPage extends StatefulWidget {
  const MiPerfilPage({super.key});

  @override
  State<MiPerfilPage> createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
  final AuthRepository _authRepository = AuthRepository();
  MeResponse? _me;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMe();
  }

  Future<void> _loadMe() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final me = await _authRepository.getMe();
      if (mounted) setState(() => _me = me);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static MiPerfilUserData _meToUserData(MeResponse me) {
    return MiPerfilUserData(
      nombreCompleto: me.nombre,
      correo: me.email,
      cargo: me.cargo ?? '-',
      carnetIdentidad: me.carnetIdentidad ?? '',
      telefono: me.telefono ?? '',
      rolSistema: me.rolNombre,
      enLinea: me.estado.toLowerCase() == 'activo',
    );
  }

  Future<void> _openCambiarContrasena() async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => const CambiarContrasenaDialog(),
    );
    if (result == null || !mounted) return;
    final (actual, nueva) = result;
    try {
      await _authRepository.cambiarContrasena(actual, nueva);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña actualizada correctamente'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _openEditarPerfil() async {
    if (_me == null) return;
    final body = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditarPerfilDialog(me: _me!),
    );
    if (body == null || !mounted) return;
    try {
      await _authRepository.updateMe(body);
      if (!mounted) return;
      await _loadMe();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } catch (e) {
      if (!mounted) return;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //const MiPerfilHeader(),
        // const MiPerfilBreadcrumb(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando perfil...'),
          ],
        ),
      );
    }

    if (_error != null || _me == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
              const SizedBox(height: 16),
              Text(
                _error ?? 'No se pudo cargar el perfil',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loadMe,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final userData = _meToUserData(_me!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mi Perfil',
            style: GoogleFonts.inter(
              color: AppColors.gray002855,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 36 / 30,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 24),
          const ScreenDescriptionCard(
            description:
                'Consulte y edite su información personal y configuración de cuenta. Puede cambiar su contraseña desde aquí.',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 24),
          MiPerfilBanner(userData: userData),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: MiPerfilPersonalInfo(
              userData: userData,
              onEditarPerfil: () => _openEditarPerfil(),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: MiPerfilAccountConfig(
              ultimaActualizacionPassword: 'hace 3 meses',
              onActualizarPassword: _openCambiarContrasena,
            ),
          ),
        ],
      ),
    );
  }
}
