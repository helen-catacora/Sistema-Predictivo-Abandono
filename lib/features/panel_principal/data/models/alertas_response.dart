/// Una alerta del listado GET /alertas.
class AlertaItem {
  AlertaItem({
    required this.id,
    required this.tipo,
    required this.nivel,
    required this.estudianteId,
    required this.nombreEstudiante,
    required this.codigoEstudiante,
    required this.paralelo,
    required this.titulo,
    required this.descripcion,
    required this.fechaCreacion,
    required this.estado,
    required this.faltasConsecutivas,
  });

  factory AlertaItem.fromJson(Map<String, dynamic> json) {
    return AlertaItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tipo: json['tipo'] as String? ?? '',
      nivel: json['nivel'] as String? ?? '',
      estudianteId: (json['estudiante_id'] as num?)?.toInt() ?? 0,
      nombreEstudiante: json['nombre_estudiante'] as String? ?? '',
      codigoEstudiante: json['codigo_estudiante'] as String? ?? '',
      paralelo: json['paralelo'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      fechaCreacion: json['fecha_creacion'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      faltasConsecutivas: (json['faltas_consecutivas'] as num?)?.toInt() ?? 0,
    );
  }

  final int id;
  final String tipo;
  final String nivel;
  final int estudianteId;
  final String nombreEstudiante;
  final String codigoEstudiante;
  final String paralelo;
  final String titulo;
  final String descripcion;
  final String fechaCreacion;
  final String estado;
  final int faltasConsecutivas;
}

/// Respuesta del endpoint GET /alertas.
class AlertasResponse {
  AlertasResponse({
    required this.total,
    required this.totalActivas,
    required this.totalCriticas,
    required this.alertas,
  });

  factory AlertasResponse.fromJson(Map<String, dynamic> json) {
    final list = json['alertas'];
    return AlertasResponse(
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalActivas: (json['total_activas'] as num?)?.toInt() ?? 0,
      totalCriticas: (json['total_criticas'] as num?)?.toInt() ?? 0,
      alertas: list is List
          ? (list)
                .map(
                  (e) =>
                      AlertaItem.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList()
          : <AlertaItem>[],
    );
  }

  final int total;
  final int totalActivas;
  final int totalCriticas;
  final List<AlertaItem> alertas;
}
