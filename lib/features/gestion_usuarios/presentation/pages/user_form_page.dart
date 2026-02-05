import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/usuario_item.dart';
import '../widgets/user_form_actions.dart';
import '../widgets/user_form_credentials.dart';
import '../widgets/user_form_modules.dart';
import '../widgets/user_form_personal_info.dart';
import '../widgets/user_form_quick_help.dart';
import '../widgets/user_form_role.dart';

/// Página de registro/edición de usuario.
class UserFormPage extends StatefulWidget {
  const UserFormPage({
    super.key,
    this.usuario,
  });

  /// Si no es null, modo edición.
  final UsuarioItem? usuario;

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _cedulaController;
  late TextEditingController _telefonoController;
  late TextEditingController _cargoController;
  late TextEditingController _correoController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String _selectedRol = 'JEFE DE CARRERA';
  bool _estadoActivo = true;
  final Set<String> _modulosSeleccionados = {
    'Panel Principal',
    'Estudiantes',
    'Asistencia',
  };

  bool get _isEditMode => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController();
    _apellidosController = TextEditingController();
    _cedulaController = TextEditingController();
    _telefonoController = TextEditingController();
    _cargoController = TextEditingController();
    _correoController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _loadUsuario();
  }

  void _loadUsuario() {
    final u = widget.usuario;
    if (u != null) {
      final partes = u.nombre.split(RegExp(r'\s+'));
      _nombresController.text = partes.isNotEmpty ? partes.first : '';
      _apellidosController.text =
          partes.length > 1 ? partes.sublist(1).join(' ') : '';
      _correoController.text = u.correo;
      _cargoController.text = u.rol;
      _selectedRol = u.rol;
      _estadoActivo = u.estado.toLowerCase() == 'activo';
    }
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _cargoController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _limpiarFormulario() {
    setState(() {
      _nombresController.clear();
      _apellidosController.clear();
      _cedulaController.clear();
      _telefonoController.clear();
      _cargoController.clear();
      _correoController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedRol = 'JEFE DE CARRERA';
      _estadoActivo = true;
      _modulosSeleccionados.clear();
      _modulosSeleccionados.addAll([
        'Panel Principal',
        'Estudiantes',
        'Asistencia',
      ]);
    });
  }

  void _guardar() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Conectar con API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode ? 'Usuario actualizado' : 'Usuario registrado',
          ),
          backgroundColor: const Color(0xFF22C55E),
        ),
      );
      context.pop();
    }
  }

  void _cancelar() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    UserFormPersonalInfo(
                      nombresController: _nombresController,
                      apellidosController: _apellidosController,
                      cedulaController: _cedulaController,
                      telefonoController: _telefonoController,
                      cargoController: _cargoController,
                    ),
                    const SizedBox(height: 24),
                    UserFormCredentials(
                      correoController: _correoController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isEditMode: _isEditMode,
                    ),
                    const SizedBox(height: 24),
                    UserFormRole(
                      selectedRol: _selectedRol,
                      estadoActivo: _estadoActivo,
                      onRolChanged: (r) => setState(() => _selectedRol = r),
                      onEstadoChanged: (v) =>
                          setState(() => _estadoActivo = v),
                    ),
                    const SizedBox(height: 24),
                    UserFormModules(
                      selectedModules: _modulosSeleccionados,
                      onToggle: (m) {
                        setState(() {
                          if (_modulosSeleccionados.contains(m)) {
                            _modulosSeleccionados.remove(m);
                          } else {
                            _modulosSeleccionados.add(m);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UserFormActions(
                      onGuardar: _guardar,
                      onLimpiar: _limpiarFormulario,
                      onCancelar: _cancelar,
                    ),
                    const SizedBox(height: 24),
                    const UserFormQuickHelp(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 20, color: AppColors.grayDark),
                const SizedBox(width: 8),
                Text(
                  'EMI - ${_isEditMode ? 'EDITAR USUARIO' : 'AGREGAR NUEVO USUARIO'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grayDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? 'Editar Usuario' : 'Registro de Nuevo Usuario',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 520,
                  child: Text(
                    'Complete los datos del usuario que tendrá acceso al sistema de predicción de deserción estudiantil.',
                    style: TextStyle(
                      color: AppColors.grayMedium,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.grayMedium),
                const SizedBox(width: 8),
                Text(
                  'Los campos marcados con * son obligatorios',
                  style: TextStyle(
                    color: AppColors.grayMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
