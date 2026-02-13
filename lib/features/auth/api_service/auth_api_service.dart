import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/login_response.dart';
import '../data/models/me_response.dart';

/// Servicio de API para autenticación.
class AuthApiService {
  AuthApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene el usuario actual en sesión.
  /// GET /api/v1/me
  Future<MeResponse> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }
    return MeResponse.fromJson(response.data!);
  }

  /// Actualiza los datos del usuario actual.
  /// PATCH /api/v1/me — body: nombre, carnet_identidad, telefono, cargo.
  Future<void> patchMe(Map<String, dynamic> body) async {
    await _dio.patch<dynamic>(ApiEndpoints.me, data: body);
  }

  /// Cambia la contraseña del usuario actual.
  /// POST /api/v1/me/cambiar-contrasena — body: contrasena_actual, contrasena_nueva.
  Future<void> postCambiarContrasena(Map<String, dynamic> body) async {
    await _dio.post<dynamic>(ApiEndpoints.meCambiarContrasena, data: body);
  }

  /// Inicia sesión con email y contraseña.
  /// POST /api/v1/auth/login
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return LoginResponse.fromJson(response.data!);
  }
}
