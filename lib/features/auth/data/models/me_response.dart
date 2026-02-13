/// Respuesta de GET /me (usuario actual en sesión).
class MeResponse {
  MeResponse({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rolId,
    required this.rolNombre,
    required this.estado,
    this.carnetIdentidad,
    this.telefono,
    this.cargo,
    this.modulos = const [],
  });

  final int id;
  final String nombre;
  final String email;
  final int rolId;
  final String rolNombre;
  final String estado;
  final String? carnetIdentidad;
  final String? telefono;
  final String? cargo;
  final List<String> modulos;

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    final modulosList = json['modulos'] as List<dynamic>?;
    return MeResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      email: json['email'] as String? ?? '',
      rolId: (json['rol_id'] as num?)?.toInt() ?? 0,
      rolNombre: json['rol_nombre'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      carnetIdentidad: json['carnet_identidad'] as String?,
      telefono: json['telefono'] as String?,
      cargo: json['cargo'] as String?,
      modulos: modulosList != null
          ? modulosList.map((e) => e.toString()).toList()
          : [],
    );
  }
}
