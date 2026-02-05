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
}
