/// Modelo de materia del endpoint /materias.
class MateriaItem {
  MateriaItem({
    required this.id,
    required this.nombre,
    required this.areaId,
    required this.semestreId,
  });

  factory MateriaItem.fromJson(Map<String, dynamic> json) {
    return MateriaItem(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      areaId: json['area_id'] as int,
      semestreId: json['semestre_id'] as int,
    );
  }

  final int id;
  final String nombre;
  final int areaId;
  final int semestreId;
}
