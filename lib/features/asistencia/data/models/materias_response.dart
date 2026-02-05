import 'materia_item.dart';

/// Respuesta del endpoint GET /materias.
class MateriasResponse {
  MateriasResponse({required this.materias});

  factory MateriasResponse.fromJson(Map<String, dynamic> json) {
    final list = json['materias'] as List<dynamic>? ?? [];
    return MateriasResponse(
      materias: list
          .map((e) => MateriaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<MateriaItem> materias;
}
