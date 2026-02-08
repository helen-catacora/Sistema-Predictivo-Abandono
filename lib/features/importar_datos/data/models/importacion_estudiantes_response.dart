/// Respuesta del endpoint POST /estudiantes/importar.
class ImportacionEstudiantesResponse {
  ImportacionEstudiantesResponse({
    required this.nombreArchivo,
    required this.totalFilas,
    this.estudiantesCreados = 0,
    this.estudiantesActualizados = 0,
    this.totalErrores = 0,
  });

  final String nombreArchivo;
  final int totalFilas;
  final int estudiantesCreados;
  final int estudiantesActualizados;
  final int totalErrores;

  factory ImportacionEstudiantesResponse.fromJson(Map<String, dynamic> json) {
    return ImportacionEstudiantesResponse(
      nombreArchivo: json['nombre_archivo'] as String? ?? '',
      totalFilas: (json['total_filas'] as num?)?.toInt() ?? 0,
      estudiantesCreados:
          (json['estudiantes_creados'] as num?)?.toInt() ?? 0,
      estudiantesActualizados:
          (json['estudiantes_actualizados'] as num?)?.toInt() ?? 0,
      totalErrores: (json['total_errores'] as num?)?.toInt() ?? 0,
    );
  }
}
