import 'estudiante_item.dart';

/// Respuesta del endpoint GET /estudiantes/tabla.
class EstudiantesTablaResponse {
  EstudiantesTablaResponse({required this.estudiantes});

  factory EstudiantesTablaResponse.fromJson(Map<String, dynamic> json) {
    final list = json['estudiantes'] as List<dynamic>? ?? [];
    return EstudiantesTablaResponse(
      estudiantes: list
          .map((e) => EstudianteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<EstudianteItem> estudiantes;
}
