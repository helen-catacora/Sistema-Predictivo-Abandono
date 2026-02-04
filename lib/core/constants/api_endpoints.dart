/// Endpoints de la API REST del backend.
abstract class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:8001/api/v1';

  /// Auth
  static const String authLogin = '/auth/login';
}
