import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistemapredictivoabandono/shared/widgets/screen_description_card.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/estudiante_perfil_response.dart';
import '../../repositories/estudiantes_repository.dart';
import '../widgets/perfil/perfil_alertas_section.dart';
import '../widgets/perfil/perfil_datos_sociodemograficos.dart';
import '../widgets/perfil/perfil_desempenio_section.dart';
import '../widgets/perfil/perfil_header_card.dart';
import '../widgets/perfil/perfil_riesgo_ml_section.dart';
import '../widgets/perfil/perfil_acciones_section.dart';

/// Pantalla de perfil de un estudiante (GET /estudiantes/:id/perfil).
class EstudiantePerfilPage extends StatefulWidget {
  const EstudiantePerfilPage({super.key, required this.estudianteId});

  final int estudianteId;

  @override
  State<EstudiantePerfilPage> createState() => _EstudiantePerfilPageState();
}

class _EstudiantePerfilPageState extends State<EstudiantePerfilPage> {
  final EstudiantesRepository _repository = EstudiantesRepository();
  EstudiantePerfilResponse? _perfil;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPerfil();
  }

  Future<void> _loadPerfil() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final p = await _repository.getPerfil(widget.estudianteId);
      if (mounted) setState(() => _perfil = p);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.grayLight,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Perfil del Estudiante'),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando perfil...'),
            ],
          ),
        ),
      );
    }

    if (_error != null || _perfil == null) {
      return Scaffold(
        backgroundColor: AppColors.grayLight,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Perfil del Estudiante'),
        ),
        body: Center(
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
                  onPressed: _loadPerfil,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final p = _perfil!;
    final probabilidad =
        (p.riesgoYPrediccion?.prediccionActual?.probabilidadAbandono ?? 0) *
        100;
    final nivelRiesgo =
        p.riesgoYPrediccion?.prediccionActual?.nivelRiesgo ?? '';

    return Scaffold(
      backgroundColor: AppColors.grayLight,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   backgroundColor: AppColors.white,
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () => context.pop(),
          //   ),
          //   title: const Text(
          //     'Perfil del Estudiante',
          //     style: TextStyle(
          //       color: AppColors.navyMedium,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 18,
          //     ),
          //   ),
          //   actions: [
          //     Container(
          //       margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 16,
          //         vertical: 12,
          //       ),
          //       decoration: BoxDecoration(
          //         color: AppColors.navyMedium,
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'PROBABILIDAD DE ABANDONO',
          //             style: TextStyle(
          //               color: Colors.white.withValues(alpha: 0.9),
          //               fontSize: 10,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //           Text(
          //             '${probabilidad.toStringAsFixed(0)}%',
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 22,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ScreenDescriptionCard(
                    description:
                        'Vista detallada del perfil del estudiante: datos básicos, sociodemográficos, riesgo de abandono, desempeño académico, alertas y acciones de seguimiento.',
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(height: 24),
                  PerfilHeaderCard(
                    datosBasicos: p.datosBasicos,
                    nivelRiesgo: nivelRiesgo,
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final useRow = constraints.maxWidth > 900;
                      if (useRow) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PerfilDatosSociodemograficos(
                                    datos: p.datosSociodemograficos,
                                    datosBasicos: p.datosBasicos,
                                  ),
                                  const SizedBox(height: 16),
                                  PerfilRiesgoMlSection(
                                    riesgoYPrediccion: p.riesgoYPrediccion,
                                    probabilidadPorcentaje: probabilidad,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PerfilDesempenioSection(
                                    desempenio: p.desempenioAcademico,
                                  ),
                                  const SizedBox(height: 16),
                                  PerfilAccionesSection(
                                    estudianteId: widget.estudianteId,
                                    loadAcciones: () => _repository.getAcciones(
                                      estudianteId: widget.estudianteId,
                                      limite: 50,
                                    ),
                                    onCreateAccion: (descripcion, fecha) async {
                                      await _repository.crearAccion(
                                        descripcion: descripcion,
                                        fecha: fecha,
                                        estudianteId: widget.estudianteId,
                                      );
                                    },
                                  ),
                                  PerfilAlertasSection(alertas: p.alertas),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PerfilDatosSociodemograficos(
                            datos: p.datosSociodemograficos,
                            datosBasicos: p.datosBasicos,
                          ),
                          const SizedBox(height: 16),
                          PerfilRiesgoMlSection(
                            riesgoYPrediccion: p.riesgoYPrediccion,
                            probabilidadPorcentaje: probabilidad,
                          ),
                          const SizedBox(height: 16),
                          PerfilAlertasSection(alertas: p.alertas),
                          const SizedBox(height: 16),
                          PerfilDesempenioSection(
                            desempenio: p.desempenioAcademico,
                          ),
                          const SizedBox(height: 16),
                          PerfilAccionesSection(
                            estudianteId: widget.estudianteId,
                            loadAcciones: () => _repository.getAcciones(
                              estudianteId: widget.estudianteId,
                              limite: 50,
                            ),
                            onCreateAccion: (descripcion, fecha) async {
                              await _repository.crearAccion(
                                descripcion: descripcion,
                                fecha: fecha,
                                estudianteId: widget.estudianteId,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
