/// Endpoints de la API REST del backend.
abstract class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:8001/api/v1';

  /// Auth
  static const String authLogin = '/auth/login';

  /// Estudiantes
  static const String estudiantesTabla = '/estudiantes/tabla';

  /// Paralelos (para asistencia)
  static const String paralelos = '/paralelos';

  /// Materias (para asistencia)
  static const String materias = '/materias';

  /// Asistencias del día (query: materia_id, paralelo_id)
  static const String asistenciasDia = '/asistencias/dia';

  /// Usuarios (gestión)
  static const String usuarios = '/usuarios';
}
