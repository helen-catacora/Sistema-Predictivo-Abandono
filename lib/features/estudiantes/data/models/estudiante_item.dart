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
  });

  factory EstudianteItem.fromJson(Map<String, dynamic> json) {
    return EstudianteItem(
      id: json['id'] as int,
      nombreCompleto: json['nombre_completo'] as String,
      carrera: json['carrera'] as String,
      codigoEstudiante: json['codigo_estudiante'] as String,
      porcentajeAsistencia: (json['porcentaje_asistencia'] as num).toInt(),
      nivelRiesgo: json['nivel_riesgo'] as String,
      promedio: (json['promedio'] as num?)?.toDouble(),
    );
  }

  final int id;
  final String nombreCompleto;
  final String carrera;
  final String codigoEstudiante;
  final int porcentajeAsistencia;
  final String nivelRiesgo;
  final double? promedio;
}
