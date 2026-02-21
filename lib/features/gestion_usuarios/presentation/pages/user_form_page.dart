import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/gestion_usuarios/presentation/providers/usuarios_provider.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/usuario_item.dart';
import '../../repositories/usuarios_repository.dart';
import '../providers/modulos_provider.dart';
import '../widgets/user_form_actions.dart';
import '../widgets/user_form_credentials.dart';
import '../widgets/user_form_modules.dart';
import '../widgets/user_form_personal_info.dart';
import '../widgets/user_form_quick_help.dart';
import '../widgets/user_form_role.dart';

/// Mapeo nombre de rol -> rol_id para PATCH /usuarios/:id (ajustar según backend).
const Map<String, int> _rolNombreToId = {
  'JEFE DE CARRERA': 1,
  'DOCENTE A DEDICACIÓN EXCLUSIVA': 2,
  'ENCARGADO DE CURSO': 3,
};

/// Página de registro/edición de usuario.
class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key, this.usuario});

  /// Si no es null, modo edición.
  final UsuarioItem? usuario;

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final UsuariosRepository _repository = UsuariosRepository();

  bool _saving = false;

  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _cedulaController;
  late TextEditingController _telefonoController;
  late TextEditingController _cargoController;
  late TextEditingController _correoController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String _selectedRol = '';
  int _selectedRolId = 999;
  bool _estadoActivo = true;
  final Set<int> _modulosSeleccionados = {};

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
      _apellidosController.text = partes.length > 1
          ? partes.sublist(1).join(' ')
          : '';
      _correoController.text = u.correo;
      _cargoController.text = u.rol;
      _selectedRol = u.rol;
      _selectedRolId = u.rolId;
      _estadoActivo = u.estado.toLowerCase() == 'activo';
      _modulosSeleccionados.addAll(u.modulos);
      _cedulaController.text = u.carnetIdentidad;
      _telefonoController.text = u.telefono;
      _cargoController.text = u.cargo;
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
    });
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_isEditMode) {
      setState(() => _saving = true);
      try {
        final nombre =
            '${_nombresController.text.trim()} ${_apellidosController.text.trim()}'
                .trim();
        // PATCH /usuarios/:id — modulos: listado de ids de módulos seleccionados
        final body = <String, dynamic>{
          'nombre': nombre.isEmpty ? ' ' : nombre,
          'carnet_identidad': _cedulaController.text.trim(),
          'telefono': _telefonoController.text.trim(),
          'cargo': _cargoController.text.trim(),
          'correo': _correoController.text.trim(),
          'rol_id': _rolNombreToId[_selectedRol.toUpperCase()] ?? 3,
          'estado': _estadoActivo ? 'activo' : 'inactivo',
          'modulos': List<int>.from(_modulosSeleccionados),
        };
        await _repository.updateUsuario(widget.usuario!.id, body);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario actualizado correctamente'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        context.read<UsuariosProvider>().loadUsuarios();
        context.pop();
      } catch (e) {
        if (!mounted) return;
        setState(() => _saving = false);
        String msg = 'Error al actualizar el usuario';
        if (e is DioException) {
          final data = e.response?.data;
          if (data is Map) {
            final detail = data['detail'];
            if (detail is String) msg = detail;
            if (detail is List && detail.isNotEmpty && detail[0] is Map) {
              msg = (detail[0] as Map)['msg']?.toString() ?? msg;
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
        );
      }
    } else {
      setState(() => _saving = true);
      try {
        final nombre =
            '${_nombresController.text.trim()} ${_apellidosController.text.trim()}'
                .trim();
        // POST /usuarios — modulos: listado de ids de módulos seleccionados
        final body = <String, dynamic>{
          'nombre': nombre.isEmpty ? ' ' : nombre,
          'carnet_identidad': _cedulaController.text.trim(),
          'telefono': _telefonoController.text.trim(),
          'cargo': _cargoController.text.trim(),
          'correo': _correoController.text.trim(),
          'contraseña': _passwordController.text,
          'rol_id': _rolNombreToId[_selectedRol.toUpperCase()] ?? 3,
          'modulos': List<int>.from(_modulosSeleccionados),
        };
        await _repository.createUsuario(body);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado correctamente'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        context.read<UsuariosProvider>().loadUsuarios();
        context.pop();
      } catch (e) {
        if (!mounted) return;
        setState(() => _saving = false);
        String msg = 'Error al registrar el usuario';
        if (e is DioException) {
          final data = e.response?.data;
          if (data is Map) {
            final detail = data['detail'];
            if (detail is String) msg = detail;
            if (detail is List && detail.isNotEmpty && detail[0] is Map) {
              msg = (detail[0] as Map)['msg']?.toString() ?? msg;
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
        );
      }
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
                      const SizedBox(height: 16),
                      const ScreenDescriptionCard(
                        description:
                            'Complete los datos del usuario para registrar un nuevo acceso o editar uno existente. Incluye datos personales, credenciales, rol y módulos asignados.',
                        icon: Icons.admin_panel_settings_outlined,
                      ),
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
                        selectedRol: _selectedRol.toUpperCase(),
                        selectedRolId: _selectedRolId,
                        estadoActivo: _estadoActivo,
                        onRolChanged: (r) => setState(() {
                          _selectedRol = r.$1;
                          _selectedRolId = r.$2;
                        }),
                        onEstadoChanged: (v) =>
                            setState(() => _estadoActivo = v),
                      ),
                      const SizedBox(height: 24),
                      Consumer<ModulosProvider>(
                        builder: (context, modulosProvider, _) {
                          return UserFormModules(
                            modulos: modulosProvider.modulos,
                            selectedModules: _modulosSeleccionados,
                            isLoading: modulosProvider.isLoading,
                            onToggle: (m) {
                              setState(() {
                                if (_modulosSeleccionados.contains(m)) {
                                  _modulosSeleccionados.remove(m);
                                } else {
                                  _modulosSeleccionados.add(m);
                                }
                              });
                            },
                          );
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
                        saving: _saving,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _isEditMode ? 'Editar Usuario' : 'Registro de Nuevo Usuario',
                  style: TextStyle(
                    color: AppColors.navyMedium,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  'Los campos marcados con * son obligatorios',
                  style: TextStyle(color: AppColors.grayMedium, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 520,
              child: Text(
                'Complete los datos del usuario que tendrá acceso al sistema de predicción de abandono estudiantil.',
                style: TextStyle(color: AppColors.grayMedium, fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
