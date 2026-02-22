import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../asistencia/data/models/paralelo_item.dart';
import '../../../asistencia/presentation/providers/paralelos_provider.dart';
import '../../../gestion_usuarios/data/models/usuario_item.dart';
import '../../../gestion_usuarios/presentation/providers/usuarios_provider.dart';

/// Diálogo para asignar un encargado a un paralelo.
void showAsignarEncargadoDialog(
  BuildContext context, {
  required ParaleloItem paralelo,
}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _AsignarEncargadoDialog(paralelo: paralelo),
  );
}

class _AsignarEncargadoDialog extends StatefulWidget {
  const _AsignarEncargadoDialog({required this.paralelo});

  final ParaleloItem paralelo;

  @override
  State<_AsignarEncargadoDialog> createState() =>
      _AsignarEncargadoDialogState();
}

class _AsignarEncargadoDialogState extends State<_AsignarEncargadoDialog> {
  UsuarioItem? _selectedUsuario;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuariosProvider>().loadUsuarios();
    });
  }

  Future<void> _confirmar(BuildContext context) async {
    if (_selectedUsuario == null) return;

    final paralelosProvider = context.read<ParalelosProvider>();
    final ok = await paralelosProvider.assignEncargado(
      widget.paralelo.id,
      _selectedUsuario!.id,
    );

    if (!context.mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Encargado asignado correctamente a ${widget.paralelo.nombre}'
              : paralelosProvider.errorMessage ?? 'Error al asignar encargado',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ok ? AppColors.green16A34A : Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Asignar encargado',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray002855,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Paralelo: ${widget.paralelo.nombre}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.grey64748B,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<UsuariosProvider>(
                  builder: (context, usuariosProvider, _) {
                    final usuarios = usuariosProvider.usuarios;
                    final activos = usuarios
                        .where((u) => u.estado.toLowerCase() == 'activo')
                        .toList();

                    if (usuariosProvider.isLoading && usuarios.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Cargando usuarios...'),
                          ],
                        ),
                      );
                    }

                    if (activos.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay usuarios activos disponibles.',
                          style: GoogleFonts.inter(
                            color: AppColors.grey64748B,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: activos.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final u = activos[i];
                        final selected = _selectedUsuario?.id == u.id;
                        return ListTile(
                          selected: selected,
                          selectedTileColor: AppColors.blueDBEAFE,
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.greyE2E8F0,
                            child: Text(
                              _iniciales(u.nombre),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray002855,
                              ),
                            ),
                          ),
                          title: Text(
                            u.nombre,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            u.correo,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey64748B,
                            ),
                          ),
                          trailing: Text(
                            u.rol,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.grey94A3B8,
                            ),
                          ),
                          onTap: () => setState(() => _selectedUsuario = u),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        color: AppColors.grey64748B,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _selectedUsuario == null
                        ? null
                        : () => _confirmar(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green16A34A,
                    ),
                    child: Consumer<ParalelosProvider>(
                      builder: (context, paralelosProvider, _) {
                        if (paralelosProvider.isAssigning) {
                          return const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }
                        return const Text('Asignar');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _iniciales(String nombre) {
    final parts = nombre.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
