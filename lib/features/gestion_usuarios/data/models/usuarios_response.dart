import 'usuario_item.dart';

/// Respuesta del endpoint GET /usuarios.
class UsuariosResponse {
  UsuariosResponse({required this.usuarios});

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) {
    final list = json['usuarios'] as List<dynamic>? ?? [];
    return UsuariosResponse(
      usuarios: list
          .map((e) => UsuarioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<UsuarioItem> usuarios;
}
