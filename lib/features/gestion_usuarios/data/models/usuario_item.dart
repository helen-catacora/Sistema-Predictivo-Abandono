/// Modelo de usuario del endpoint GET /usuarios.
class UsuarioItem {
  UsuarioItem({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.estado,
    this.modulos = const <int>[],
    required this.rolId,
    required this.cargo,
    required this.telefono,
    required this.carnetIdentidad,
  });

  factory UsuarioItem.fromJson(Map<String, dynamic> json) {
    return UsuarioItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      rol: json['rol'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      modulos:
          (json['modulos'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      rolId: json['rol_id'],
      cargo: json['cargo'] ?? '',
      telefono: json['telefono'] ?? '',
      carnetIdentidad: json['carnet_identidad'] ?? '',
    );
  }

  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final String estado;
  final List<int> modulos;
  final int rolId;
  final String cargo;
  final String telefono;
  final String carnetIdentidad;
}
