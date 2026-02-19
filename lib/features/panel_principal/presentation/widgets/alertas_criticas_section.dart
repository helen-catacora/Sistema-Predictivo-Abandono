import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/alertas_response.dart';
import '../providers/alertas_provider.dart';

/// Máximo de alertas a mostrar en la sección (solo las 3 primeras).
const int _maxAlertasVisibles = 3;

/// Fondo gris claro del panel de alertas.
const Color _kPanelBackground = Color(0xFFF0F2F5);
const Color _kCardBackground = Color(0xFFFFFFFF);
const Color _kTitleColor = Color(0xFF212B36);
const Color _kTextSecondary = Color(0xFF616161);
const Color _kBarCritico = Color(0xFFE53935);
const Color _kBarAlto = Color(0xFFFF9800);
const Color _kAvatarBackground = Color(0xFF212B36);
const Color _kVerPerfilYellow = Color(0xFFFFEB3B);

void _showTodasLasAlertasDialog(
  BuildContext context,
  List<AlertaItem> alertas,
) {
  // Usar el router del shell (dashboard) para que el push mantenga el sidebar visible.
  final router = GoRouter.of(context);
  showDialog<void>(
    context: context,
    barrierColor: _kPanelBackground,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
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
          mainAxisSize: MainAxisSize.min,
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
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(dialogContext).size.height * 0.55,
              ),
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
                        Navigator.of(dialogContext).pop();
                        router.push(AppRoutes.homeEstudiantePerfil(alerta.estudianteId));
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
                    onPressed: () => Navigator.of(dialogContext).pop(),
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

/// Tarjeta de alerta para el panel "Todas las Alertas" (fondo blanco, barra lateral, Ver Perfil).
class _AlertaCard extends StatelessWidget {
  const _AlertaCard({
    required this.alerta,
    required this.onVerPerfil,
  });

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
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
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

/// Sección Alertas Críticas (datos de GET /alertas).
class AlertasCriticasSection extends StatelessWidget {
  const AlertasCriticasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertasProvider>(
      builder: (context, alertasProvider, _) {
        final isLoading = alertasProvider.isLoading;
        final hasError = alertasProvider.hasError;
        final lista = alertasProvider.alertasPrioritarias;
        final visible = lista.take(_maxAlertasVisibles).toList();

        return Container(
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.navyMedium,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.accentYellow,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Alertas Críticas',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isLoading && visible.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accentYellow,
                      ),
                    ),
                  ),
                )
              else if (hasError && visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    alertasProvider.errorMessage ?? 'Error al cargar alertas',
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontSize: 13,
                    ),
                  ),
                )
              else if (visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No hay alertas en este momento.',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 156, 156, 156),
                      fontSize: 13,
                    ),
                  ),
                )
              else
                ...visible.asMap().entries.map((e) {
                  final i = e.key;
                  final alerta = e.value;
                  return Padding(
                    padding: i < visible.length - 1
                        ? const EdgeInsets.only(bottom: 12)
                        : EdgeInsets.zero,
                    child: _AlertItemFromApi(alerta: alerta),
                  );
                }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: lista.isEmpty
                      ? null
                      : () {
                        GoRouter.of(context).push(AppRoutes.homePanelAllAlertas);
                      },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.list_alt, size: 20),
                  label: const Text(
                    'Ver Todas las Alertas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertItemFromApi extends StatelessWidget {
  const _AlertItemFromApi({
    required this.alerta,
    this.onVerPerfil,
  });

  final AlertaItem alerta;
  /// Si no es null, se muestra el botón "Ver Perfil" (p. ej. en el diálogo).
  final VoidCallback? onVerPerfil;

  /// Texto principal: se prioriza descripcion (response GET /alertas).
  String get _detail {
    if (alerta.descripcion.isNotEmpty) return alerta.descripcion;
    if (alerta.titulo.isNotEmpty) return alerta.titulo;
    if (alerta.faltasConsecutivas > 0) {
      return 'Faltas consecutivas: ${alerta.faltasConsecutivas}';
    }
    if (alerta.paralelo.isNotEmpty) return 'Paralelo: ${alerta.paralelo}';
    if (alerta.codigoEstudiante.isNotEmpty) {
      return 'Código: ${alerta.codigoEstudiante}';
    }
    return alerta.tipo.isNotEmpty ? alerta.tipo : '—';
  }

  Color get _detailColor {
    final n = alerta.nivel.toLowerCase();
    if (n.contains('critico') || n.contains('crítico')) return Colors.red.shade300;
    if (n.contains('alto')) return Colors.orange;
    return AppColors.grayMedium;
  }

  String get _badgeLabel {
    final n = alerta.nivel;
    if (n.isEmpty) return 'ALERTA';
    return n.toUpperCase();
  }

  Color get _badgeColor {
    final n = alerta.nivel.toLowerCase();
    if (n.contains('critico') || n.contains('crítico')) return Colors.red;
    if (n.contains('alto')) return Colors.orange;
    return AppColors.accentYellow;
  }

  @override
  Widget build(BuildContext context) {
    final name = alerta.nombreEstudiante.isNotEmpty
        ? alerta.nombreEstudiante
        : 'Estudiante ${alerta.codigoEstudiante.isNotEmpty ? alerta.codigoEstudiante : alerta.estudianteId}';
    final initial = name.isNotEmpty ? name[0] : '?';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navyDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.navyDark,
            child: Text(
              initial.toUpperCase(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (alerta.titulo.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    alerta.titulo,
                    style: TextStyle(
                      color: _detailColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (alerta.descripcion.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    alerta.descripcion,
                    style: TextStyle(
                      color: _detailColor,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (alerta.titulo.isEmpty && alerta.descripcion.isEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _detail,
                    style: TextStyle(
                      color: _detailColor,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _badgeLabel,
              style: TextStyle(
                color: _badgeColor == AppColors.accentYellow
                    ? AppColors.grayDark
                    : AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (onVerPerfil != null) ...[
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onVerPerfil,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.grayDark,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Ver Perfil'),
            ),
          ],
        ],
      ),
    );
  }
}
