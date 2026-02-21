/// Endpoints de la API REST del backend.
abstract class ApiEndpoints {
  ApiEndpoints._();

  // static const String baseUrl = 'http://localhost:8001/api/v1';
  static const String baseUrl =
      'https://zm6w6tkz-8001.brs.devtunnels.ms/api/v1';

  /// Auth
  static const String authLogin = '/auth/login';

  /// Usuario actual en sesión. GET /me
  static const String me = '/me';

  /// Cambiar contraseña del usuario actual. POST /me/cambiar-contrasena
  static const String meCambiarContrasena = '/me/cambiar-contrasena';

  /// Estudiantes
  static const String estudiantesTabla = '/estudiantes/tabla';

  /// Estudiantes - importar desde Excel (POST multipart/form-data con archivo .xlsx)
  static const String estudiantesImportar = '/estudiantes/importar';

  /// Estudiantes - resumen de importaciones. GET /estudiantes/resumen-importaciones
  static const String estudiantesResumenImportaciones =
      '/estudiantes/resumen-importaciones';

  /// Estudiantes - perfil por id. GET /estudiantes/:id/perfil
  static String estudiantePerfil(int id) => '/estudiantes/$id/perfil';

  /// Paralelos (para asistencia). GET /paralelos, PATCH /paralelos/:id
  static const String paralelos = '/paralelos';
  static String paralelo(int id) => '/paralelos/$id';

  /// Materias (para asistencia)
  static const String materias = '/materias';

  /// Asistencias del día (query: materia_id, paralelo_id)
  static const String asistenciasDia = '/asistencias/dia';

  /// Usuarios (gestión)
  static const String usuarios = '/usuarios';

  /// Usuarios - actualizar uno. PATCH /usuarios/:id
  static String usuario(int id) => '/usuarios/$id';

  /// Módulos del sistema (para asignación a usuarios). GET /modulos
  static const String modulos = '/modulos';

  /// Predicciones - dashboard (resumen, distribución riesgo, por paralelo)
  static const String prediccionesDashboard = '/predicciones/dashboard';

  /// Predicciones - carga masiva (POST multipart/form-data con archivo xlsx)
  static const String prediccionesMasiva = '/predicciones/masiva';

  /// Predicciones - resumen de importaciones. GET /predicciones/resumen-importaciones
  static const String prediccionesResumenImportaciones =
      '/predicciones/resumen-importaciones';

  /// Alertas (listado con total, activas, críticas)
  static const String alertas = '/alertas';

  /// Reportes - tipos disponibles (GET /reportes/tipos)
  static const String reportesTipos = '/reportes/tipos';

  /// Reportes - generar PDF (POST /reportes/generar)
  static const String reportesGenerar = '/reportes/generar';

  /// Reportes - historial paginado (GET /reportes/historial?page=1&page_size=20)
  static const String reportesHistorial = '/reportes/historial';

  /// Acciones de seguimiento. POST /acciones (body: descripcion, fecha, estudiante_id)
  static const String acciones = '/acciones';
}
