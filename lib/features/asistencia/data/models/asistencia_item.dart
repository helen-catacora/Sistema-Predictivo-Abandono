/// Parsea el ID del estudiante desde distintas claves posibles del API.
int _parseEstudianteId(Map<String, dynamic> json) {
  int? from(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  return from(json['estudiante_id']) ??
      from(json['student_id']) ??
      from(json['id']) ??
      (() {
        final est = json['estudiante'];
        if (est is Map) return from(est['id']);
        return null;
      })() ??
      0;
}

/// Modelo de asistencia individual del endpoint /asistencias/dia.
class AsistenciaItem {
  AsistenciaItem({
    required this.estudianteId,
    required this.materiaId,
    required this.paraleloId,
    required this.paralelo,
    required this.nombreEstudiante,
    required this.codigoEstudiante,
    required this.estado,
    required this.observacion,
  });

  factory AsistenciaItem.fromJson(Map<String, dynamic> json) {
    final estudianteId = _parseEstudianteId(json);
    return AsistenciaItem(
      estudianteId: estudianteId,
      materiaId: json['materia_id'] as int? ?? 0,
      paraleloId: json['paralelo_id'] as int? ?? 0,
      paralelo: json['paralelo'] as String? ?? '',
      nombreEstudiante: json['nombre_estudiante'] as String? ?? '',
      codigoEstudiante: json['codigo_estudiante'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      observacion: json['observacion'] as String? ?? '',
    );
  }

  final int estudianteId;
  final int materiaId;
  final int paraleloId;
  final String paralelo;
  final String nombreEstudiante;
  final String codigoEstudiante;
  final String estado;
  final String observacion;
}
