import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/login_response.dart';

/// Servicio de API para autenticación.
class AuthApiService {
  AuthApiService() : _dio = DioClient.instance;

  final Dio _dio;

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
