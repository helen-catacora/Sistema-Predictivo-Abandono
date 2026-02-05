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
}
