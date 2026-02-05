import 'asistencia_item.dart';

/// Respuesta del endpoint GET /asistencias/dia.
class AsistenciaDiaResponse {
  AsistenciaDiaResponse({
    required this.materiaId,
    required this.materiaNombre,
    required this.totalEstudiantes,
    required this.totalPresentes,
    required this.totalAusentes,
    required this.porcentajeAsistenciaDia,
    required this.asistencias,
  });

  factory AsistenciaDiaResponse.fromJson(Map<String, dynamic> json) {
    final list = json['asistencias'] as List<dynamic>? ?? [];
    return AsistenciaDiaResponse(
      materiaId: json['materia_id'] as int? ?? 0,
      materiaNombre: json['materia_nombre'] as String? ?? '',
      totalEstudiantes: json['total_estudiantes'] as int? ?? 0,
      totalPresentes: json['total_presentes'] as int? ?? 0,
      totalAusentes: json['total_ausentes'] as int? ?? 0,
      porcentajeAsistenciaDia:
          (json['porcentaje_asistencia_dia'] as num?)?.toDouble() ?? 0.0,
      asistencias: list
          .map((e) => AsistenciaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int materiaId;
  final String materiaNombre;
  final int totalEstudiantes;
  final int totalPresentes;
  final int totalAusentes;
  final double porcentajeAsistenciaDia;
  final List<AsistenciaItem> asistencias;
}
