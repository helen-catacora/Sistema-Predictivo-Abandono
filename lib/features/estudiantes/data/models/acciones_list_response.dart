/// Item de acción del listado GET /acciones.
class AccionListItem {
  AccionListItem({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.prediccionId,
    required this.estudianteId,
    required this.estudianteNombre,
    required this.fechaPrediccion,
    required this.nivelRiesgo,
  });

  factory AccionListItem.fromJson(Map<String, dynamic> json) {
    return AccionListItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      descripcion: json['descripcion'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      prediccionId: (json['prediccion_id'] as num?)?.toInt() ?? 0,
      estudianteId: (json['estudiante_id'] as num?)?.toInt() ?? 0,
      estudianteNombre: json['estudiante_nombre'] as String? ?? '',
      fechaPrediccion: json['fecha_prediccion'] as String? ?? '',
      nivelRiesgo: json['nivel_riesgo'] as String? ?? '',
    );
  }

  final int id;
  final String descripcion;
  final String fecha;
  final int prediccionId;
  final int estudianteId;
  final String estudianteNombre;
  final String fechaPrediccion;
  final String nivelRiesgo;
}

/// Respuesta de GET /acciones?estudiante_id=&limite=.
class AccionesListResponse {
  AccionesListResponse({
    required this.total,
    required this.acciones,
  });

  factory AccionesListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['acciones'] as List<dynamic>?;
    return AccionesListResponse(
      total: (json['total'] as num?)?.toInt() ?? 0,
      acciones: list != null
          ? list
              .map((e) => AccionListItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  final int total;
  final List<AccionListItem> acciones;
}
