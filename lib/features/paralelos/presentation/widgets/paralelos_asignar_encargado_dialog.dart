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
  bool _encargadoPreseleccionado = false;

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Encabezado navy ──────────────────────────────────────
            Container(
              color: AppColors.gray002855,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.manage_accounts,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Asignar Encargado',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Paralelo ${widget.paralelo.nombre}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.greyE2E8F0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Lista de usuarios ─────────────────────────────────────
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

                  // Pre-seleccionar el encargado actual una sola vez
                  if (!_encargadoPreseleccionado && activos.isNotEmpty) {
                    _encargadoPreseleccionado = true;
                    final match = activos.cast<UsuarioItem?>().firstWhere(
                      (u) => u!.id == widget.paralelo.encargadoId,
                      orElse: () => null,
                    );
                    if (match != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _selectedUsuario = match);
                      });
                    }
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: activos.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final u = activos[i];
                      final selected = _selectedUsuario?.id == u.id;
                      final esActual = u.id == widget.paralelo.encargadoId;

                      return _UsuarioTile(
                        usuario: u,
                        selected: selected,
                        esActual: esActual,
                        onTap: () => setState(() => _selectedUsuario = u),
                      );
                    },
                  );
                },
              ),
            ),

            // ── Divider ───────────────────────────────────────────────
            const Divider(height: 1, color: AppColors.greyE2E8F0),

            // ── Footer con botones ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.greyE2E8F0),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.inter(
                          color: AppColors.grey64748B,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer<ParalelosProvider>(
                      builder: (context, paralelosProvider, _) {
                        return FilledButton(
                          onPressed: _selectedUsuario == null || paralelosProvider.isAssigning
                              ? null
                              : () => _confirmar(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.green16A34A,
                            disabledBackgroundColor:
                                AppColors.green16A34A.withValues(alpha: 0.4),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: paralelosProvider.isAssigning
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Asignar',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile individual de usuario en la lista.
class _UsuarioTile extends StatelessWidget {
  const _UsuarioTile({
    required this.usuario,
    required this.selected,
    required this.esActual,
    required this.onTap,
  });

  final UsuarioItem usuario;
  final bool selected;
  final bool esActual;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? AppColors.greyF1F5F9 : Colors.white,
          border: Border(
            left: BorderSide(
              color: selected ? AppColors.gray002855 : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: selected
                  ? AppColors.gray002855
                  : AppColors.greyE2E8F0,
              child: Text(
                _iniciales(usuario.nombre),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : AppColors.gray002855,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Nombre + correo + badge "actual"
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          usuario.nombre,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.darkBlue1E293B,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (esActual) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blueDBEAFE,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Actual',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue1D4ED8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    usuario.correo,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey64748B,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Trailing: check si seleccionado, pill de rol si no
            selected
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.green16A34A,
                    size: 22,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greyF1F5F9,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.greyE2E8F0),
                    ),
                    child: Text(
                      usuario.rol,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.grey64748B,
                      ),
                    ),
                  ),
          ],
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
