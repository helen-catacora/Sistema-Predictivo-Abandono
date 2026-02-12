import '../api_service/usuarios_api_service.dart';
import '../data/models/usuario_item.dart';
import '../data/models/usuarios_response.dart';

/// Repositorio de usuarios.
class UsuariosRepository {
  UsuariosRepository({UsuariosApiService? apiService})
      : _apiService = apiService ?? UsuariosApiService();

  final UsuariosApiService _apiService;

  /// Obtiene la lista de usuarios.
  Future<List<UsuarioItem>> getUsuarios() async {
    final response = await _apiService.getUsuarios();
    return response.usuarios;
  }

  /// Actualiza un usuario (PATCH /usuarios/:id).
  Future<void> updateUsuario(int id, Map<String, dynamic> body) async {
    await _apiService.patchUsuario(id, body);
  }

  /// Crea un usuario (POST /usuarios).
  Future<void> createUsuario(Map<String, dynamic> body) async {
    await _apiService.postUsuario(body);
  }
}
