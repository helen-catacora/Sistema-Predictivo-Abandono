/// Modelo de estudiante del endpoint /estudiantes/tabla.
class EstudianteItem {
  EstudianteItem({
    required this.id,
    required this.nombreCompleto,
    required this.carrera,
    required this.codigoEstudiante,
    required this.porcentajeAsistencia,
    required this.nivelRiesgo,
    this.promedio,
    this.probabilidadAbandono,
    this.clasificacion,
  });

  factory EstudianteItem.fromJson(Map<String, dynamic> json) {
    return EstudianteItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombreCompleto: json['nombre_completo'] as String? ?? '',
      carrera: json['carrera'] as String? ?? '',
      codigoEstudiante: json['codigo_estudiante'] as String? ?? '',
      porcentajeAsistencia: (json['porcentaje_asistencia'] as num?)?.toInt() ?? 0,
      nivelRiesgo: json['nivel_riesgo'] as String? ?? '',
      promedio: (json['promedio'] as num?)?.toDouble(),
      probabilidadAbandono: (json['probabilidad_abandono'] as num?)?.toDouble(),
      clasificacion: json['clasificacion_abandono'] as String?,
    );
  }

  final int id;
  final String nombreCompleto;
  final String carrera;
  final String codigoEstudiante;
  final int porcentajeAsistencia;
  final String nivelRiesgo;
  final double? promedio;
  /// Probabilidad de abandono (0–1) del modelo predictivo.
  final double? probabilidadAbandono;
  /// Clasificación de abandono del endpoint (ej. "Abandona", "No Abandona").
  final String? clasificacion;
}
