/// Modelo para el body del POST /asistencias/dia.
class AsistenciaSaveRequest {
  AsistenciaSaveRequest({required this.asistencias});

  Map<String, dynamic> toJson() => {
        'asistencias': asistencias.map((a) => a.toJson()).toList(),
      };

  final List<AsistenciaSaveItem> asistencias;
}

class AsistenciaSaveItem {
  AsistenciaSaveItem({
    required this.estudianteId,
    required this.estado,
    required this.observacion,
  });

  Map<String, dynamic> toJson() => {
        'estudiante_id': estudianteId,
        'estado': estado,
        'observacion': observacion,
      };

  final int estudianteId;
  final String estado;
  final String observacion;
}
