/// Endpoints de la API REST del backend.
abstract class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:8001/api/v1';
  // static const String baseUrl = 'https://sistema-predictivo-api.onrender.com/api/v1';

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

  /// Estudiantes - plantilla Excel. GET /estudiantes/plantilla
  static const String estudiantesPlantilla = '/estudiantes/plantilla';

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

  /// Predicciones - plantilla Excel. GET /predicciones/plantilla
  static const String prediccionesPlantilla = '/predicciones/plantilla';

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

  /// Malla curricular - importar desde Excel (POST multipart/form-data: archivo .xlsx, nombre_malla)
  static const String mallaCurricularImportar = '/malla-curricular/importar';

  /// Gestiones académicas
  static const String gestiones = '/gestiones';
  static String gestionActivar(int id) => '/gestiones/$id/activar';
  static String gestionVentana(int id) => '/gestiones/$id/ventana';

  /// Períodos de registro de malla curricular
  static const String periodosRegistroMalla = '/periodos-registro-malla';
  static String periodoRegistroMallaActivar(int id) => '/periodos-registro-malla/$id/activar';
  static String periodoRegistroMallaDesactivar(int id) => '/periodos-registro-malla/$id/desactivar';

  /// Entrenamiento del modelo ML
  static const String entrenamientoIniciar = '/entrenamiento/iniciar';
  static String entrenamientoEstado(int id) => '/entrenamiento/$id/estado';
  static String entrenamientoAceptar(int id) => '/entrenamiento/$id/aceptar';
  static String entrenamientoRechazar(int id) => '/entrenamiento/$id/rechazar';
  static const String entrenamientoHistorial = '/entrenamiento/historial';
  static const String entrenamientoPlantilla = '/entrenamiento/plantilla';
  static const String entrenamientoModeloActual = '/entrenamiento/modelo-actual';
}
