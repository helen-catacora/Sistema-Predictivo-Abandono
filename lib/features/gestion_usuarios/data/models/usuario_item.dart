/// Modelo de usuario del endpoint GET /usuarios.
class UsuarioItem {
  UsuarioItem({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.estado,
  });

  factory UsuarioItem.fromJson(Map<String, dynamic> json) {
    return UsuarioItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      rol: json['rol'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
    );
  }

  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final String estado;
}
