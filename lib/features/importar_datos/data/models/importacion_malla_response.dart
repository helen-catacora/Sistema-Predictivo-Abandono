/// Respuesta del endpoint POST /malla-curricular/importar.
class ImportacionMallaResponse {
  ImportacionMallaResponse({
    required this.nombreArchivo,
    required this.filasProcesadas,
    this.registrosCreados = 0,
    this.materiasCreadas = 0,
    this.yaExistentes = 0,
    this.errores = const [],
  });

  final String nombreArchivo;
  final int filasProcesadas;
  final int registrosCreados;
  final int materiasCreadas;
  final int yaExistentes;
  final List<ImportacionMallaErrorItem> errores;

  factory ImportacionMallaResponse.fromJson(Map<String, dynamic> json) {
    final erroresList = json['errores'] as List<dynamic>? ?? [];
    return ImportacionMallaResponse(
      nombreArchivo: json['nombre_archivo'] as String? ?? '',
      filasProcesadas: (json['filas_procesadas'] as num?)?.toInt() ?? 0,
      registrosCreados: (json['registros_creados'] as num?)?.toInt() ?? 0,
      materiasCreadas: (json['materias_creadas'] as num?)?.toInt() ?? 0,
      yaExistentes: (json['ya_existentes'] as num?)?.toInt() ?? 0,
      errores: erroresList
          .map((e) => ImportacionMallaErrorItem.fromJson(
                e is Map ? Map<String, dynamic>.from(e) : {},
              ))
          .toList(),
    );
  }
}

class ImportacionMallaErrorItem {
  ImportacionMallaErrorItem({
    required this.fila,
    required this.detalle,
  });

  final int fila;
  final String detalle;

  factory ImportacionMallaErrorItem.fromJson(Map<String, dynamic> json) {
    return ImportacionMallaErrorItem(
      fila: (json['fila'] as num?)?.toInt() ?? 0,
      detalle: json['detalle'] as String? ?? '',
    );
  }
}
