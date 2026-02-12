import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/usuarios_response.dart';

/// Servicio de API para usuarios.
class UsuariosApiService {
  UsuariosApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene la lista de usuarios.
  /// GET /api/v1/usuarios
  Future<UsuariosResponse> getUsuarios() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.usuarios,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return UsuariosResponse.fromJson(response.data!);
  }

  /// Actualiza un usuario por id.
  /// PATCH /api/v1/usuarios/:id
  /// Body: nombre, carnet_identidad, telefono, cargo, correo, rol_id, estado, modulos.
  Future<void> patchUsuario(int id, Map<String, dynamic> body) async {
    await _dio.patch<dynamic>(
      ApiEndpoints.usuario(id),
      data: body,
    );
  }

  /// Crea un usuario.
  /// POST /api/v1/usuarios
  /// Body: nombre, carnet_identidad, telefono, cargo, correo, contraseña, rol_id.
  Future<void> postUsuario(Map<String, dynamic> body) async {
    await _dio.post<dynamic>(
      ApiEndpoints.usuarios,
      data: body,
    );
  }
}
