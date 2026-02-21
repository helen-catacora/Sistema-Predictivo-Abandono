import 'package:dio/dio.dart';

import '../../../core/storage/token_storage.dart';
import '../api_service/auth_api_service.dart';
import '../data/models/login_response.dart';
import '../data/models/me_response.dart';

/// Excepción cuando las credenciales son incorrectas.
class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

/// Repositorio de autenticación.
class AuthRepository {
  AuthRepository({AuthApiService? apiService})
      : _apiService = apiService ?? AuthApiService();

  final AuthApiService _apiService;

  /// Inicia sesión. Si [saveToken] es true, guarda el token en caché.
  /// [saveToken] en false: solo valida credenciales (para mostrar reCAPTCHA antes de persistir).
  /// [recaptchaToken] token de reCAPTCHA v2 (Flutter web). El backend debe verificarlo con la SECRET KEY.
  Future<LoginResponse> login({
    required String email,
    required String password,
    String? recaptchaToken,
    bool saveToken = true,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
        recaptchaToken: recaptchaToken,
      );
      if (saveToken) {
        await TokenStorage.saveToken(response.accessToken, response.rolId);
      }
      return response;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      String? msg;
      if (data is Map<String, dynamic>) {
        msg = data['detail'] as String? ?? data['message'] as String?;
      }
      if (statusCode == 401 || statusCode == 422) {
        throw AuthException(msg ?? 'Correo o contraseña incorrectos');
      }
      if (statusCode != null && statusCode >= 500) {
        throw AuthException('Error del servidor. Intente más tarde.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw AuthException('No se pudo conectar con el servidor');
      }
      throw AuthException(msg ?? e.message ?? 'Error al iniciar sesión');
    }
  }

  /// Guarda el token a partir de una respuesta de login (tras validar reCAPTCHA).
  Future<void> saveTokenFromResponse(LoginResponse response) async {
    await TokenStorage.saveToken(response.accessToken, response.rolId);
  }

  /// Cierra sesión eliminando el token.
  Future<void> logout() async {
    await TokenStorage.clear();
  }

  /// Devuelve true si hay token guardado.
  bool get isLoggedIn => TokenStorage.hasToken;

  /// Obtiene el token actual.
  String? get accessToken => TokenStorage.getAccessToken();

  /// Obtiene el rol_id del usuario actual.
  int? get rolId => TokenStorage.getRolId();

  /// Obtiene los datos del usuario actual (GET /me).
  Future<MeResponse> getMe() async {
    return _apiService.getMe();
  }

  /// Actualiza los datos del usuario actual (PATCH /me).
  Future<void> updateMe(Map<String, dynamic> body) async {
    await _apiService.patchMe(body);
  }

  /// Cambia la contraseña del usuario actual (POST /me/cambiar-contrasena).
  Future<void> cambiarContrasena(String contrasenaActual, String contrasenaNueva) async {
    await _apiService.postCambiarContrasena({
      'contrasena_actual': contrasenaActual,
      'contrasena_nueva': contrasenaNueva,
    });
  }
}
