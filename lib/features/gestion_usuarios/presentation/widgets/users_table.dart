import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/usuario_item.dart';
import '../providers/usuarios_provider.dart';

/// Genera iniciales a partir del nombre (ej: "Juan Pérez" -> "JP").
String _iniciales(String nombre) {
  final partes = nombre.trim().split(RegExp(r'\s+'));
  if (partes.isEmpty) return '';
  if (partes.length == 1) {
    final s = partes.first;
    return s.length >= 2 ? s.substring(0, 2).toUpperCase() : s.toUpperCase();
  }
  return (partes.first[0] + partes.last[0]).toUpperCase();
}

/// Tabla de usuarios registrados.
class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuariosProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return _buildLoading(context);
        }
        if (provider.hasError) {
          return _buildError(
            context,
            provider.errorMessage ?? 'Error desconocido',
            provider.loadUsuarios,
          );
        }
        return _buildTable(context, provider.usuarios);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<UsuarioItem> usuarios) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 72,
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xff001233),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'NOMBRE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'CORREO INSTITUCIONAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ROL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ESTADO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'OPERACIONES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: usuarios
                      .map(
                        (u) => DataRow(
                          cells: [
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: _isAdmin(u.rol)
                                        ? AppColors.navyMedium
                                        : AppColors.grayLight,
                                    child: Text(
                                      _iniciales(u.nombre),
                                      style: TextStyle(
                                        color: _isAdmin(u.rol)
                                            ? AppColors.white
                                            : AppColors.grayDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        u.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        u.rol,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(u.correo)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _isAdmin(u.rol)
                                      ? AppColors.navyMedium
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: _isAdmin(u.rol)
                                      ? null
                                      : Border.all(color: Colors.grey.shade400),
                                ),
                                child: Text(
                                  u.rol,
                                  style: TextStyle(
                                    color: _isAdmin(u.rol)
                                        ? AppColors.white
                                        : AppColors.grayDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _isActivo(u.estado)
                                          ? const Color(0xFF22C55E)
                                          : Colors.grey.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isActivo(u.estado) ? 'Activo' : 'Inactivo',
                                    style: TextStyle(
                                      color: _isActivo(u.estado)
                                          ? const Color(0xFF22C55E)
                                          : Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              TextButton.icon(
                                onPressed: () => context.push(
                                  AppRoutes.userFormEditar,
                                  extra: u,
                                ),
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.grey.shade600,
                                ),
                                label: Text(
                                  'EDITAR',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isAdmin(String rol) {
    final r = rol.toUpperCase();
    return r.contains('ADMIN') || r.contains('ADMINISTRADOR');
  }

  bool _isActivo(String estado) {
    return estado.toLowerCase().trim() == 'activo';
  }
}
