import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/core/constants/app_colors.dart';
import 'package:sistemapredictivoabandono/core/router/app_router.dart';
import 'package:sistemapredictivoabandono/features/panel_principal/data/models/alertas_response.dart';
import 'package:sistemapredictivoabandono/features/panel_principal/presentation/providers/alertas_provider.dart';

const Color _kCardBackground = Color(0xFFFFFFFF);
const Color _kTitleColor = Color(0xFF212B36);
const Color _kTextSecondary = Color(0xFF616161);
const Color _kBarCritico = Color(0xFFE53935);
const Color _kBarAlto = Color(0xFFFF9800);
const Color _kAvatarBackground = Color(0xFF212B36);
const Color _kVerPerfilYellow = Color(0xFFFFEB3B);

class AllAlertasPage extends StatelessWidget {
  const AllAlertasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertas = context.read<AlertasProvider>().alertasPrioritarias;
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          decoration: BoxDecoration(
            color: _kCardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.accentYellow,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Todas las Alertas',
                      style: TextStyle(
                        color: _kTitleColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  itemCount: alertas.length,
                  itemBuilder: (_, i) {
                    final alerta = alertas[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _AlertaCard(
                        alerta: alerta,
                        onVerPerfil: () {
                          GoRouter.of(context).push(
                            AppRoutes.homeEstudiantePerfil(alerta.estudianteId),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          color: _kTitleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertaCard extends StatelessWidget {
  const _AlertaCard({required this.alerta, required this.onVerPerfil});

  final AlertaItem alerta;
  final VoidCallback onVerPerfil;

  Color get _barColor {
    final n = alerta.nivel.toLowerCase();
    if (n.contains('critico') || n.contains('crítico')) return _kBarCritico;
    if (n.contains('alto')) return _kBarAlto;
    return _kBarAlto;
  }

  String get _badgeLabel {
    final n = alerta.nivel;
    if (n.isEmpty) return 'ALERTA';
    return n.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = alerta.nombreEstudiante.isNotEmpty
        ? alerta.nombreEstudiante
        : 'Estudiante ${alerta.codigoEstudiante.isNotEmpty ? alerta.codigoEstudiante : alerta.estudianteId}';
    final initial = name.isNotEmpty ? name[0] : '?';
    final titulo = alerta.titulo.isNotEmpty
        ? alerta.titulo
        : (alerta.nivel.isNotEmpty ? 'Riesgo ${alerta.nivel}' : '');
    final descripcion = alerta.descripcion;

    return Container(
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: _barColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: _kAvatarBackground,
                      child: Text(
                        initial.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: _kTitleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (titulo.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              titulo,
                              style: TextStyle(
                                color: _barColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (descripcion.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              descripcion,
                              style: const TextStyle(
                                color: _kTextSecondary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _barColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _badgeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: onVerPerfil,
                          style: FilledButton.styleFrom(
                            backgroundColor: _kVerPerfilYellow,
                            foregroundColor: _kTitleColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          child: const Text('Ver Perfil'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
