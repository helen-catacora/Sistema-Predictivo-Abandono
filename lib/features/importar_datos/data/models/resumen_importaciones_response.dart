/// Respuesta de GET /predicciones/resumen-importaciones.
class ResumenImportacionesResponse {
  ResumenImportacionesResponse({
    required this.totalImportaciones,
    this.ultimaImportacion,
  });

  factory ResumenImportacionesResponse.fromJson(Map<String, dynamic> json) {
    final ultima = json['ultima_importacion'];
    return ResumenImportacionesResponse(
      totalImportaciones: (json['total_importaciones'] as num?)?.toInt() ?? 0,
      ultimaImportacion: ultima != null && ultima is Map
          ? UltimaImportacionItem.fromJson(
              Map<String, dynamic>.from(ultima as Map),
            )
          : null,
    );
  }

  final int totalImportaciones;
  final UltimaImportacionItem? ultimaImportacion;
}

/// Item de última importación.
class UltimaImportacionItem {
  UltimaImportacionItem({
    required this.nombreArchivo,
    required this.fechaCarga,
    required this.cantidadRegistros,
  });

  factory UltimaImportacionItem.fromJson(Map<String, dynamic> json) {
    return UltimaImportacionItem(
      nombreArchivo: json['nombre_archivo'] as String? ?? '',
      fechaCarga: json['fecha_carga'] as String? ?? '',
      cantidadRegistros: (json['cantidad_registros'] as num?)?.toInt() ?? 0,
    );
  }

  final String nombreArchivo;
  final String fechaCarga;
  final int cantidadRegistros;
}
