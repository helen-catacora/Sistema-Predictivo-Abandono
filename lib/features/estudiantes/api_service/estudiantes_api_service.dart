import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/acciones_list_response.dart';
import '../data/models/estudiante_perfil_response.dart';
import '../data/models/estudiantes_tabla_response.dart';

/// Servicio de API para estudiantes.
class EstudiantesApiService {
  EstudiantesApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene la tabla de estudiantes en riesgo.
  /// GET /api/v1/estudiantes/tabla — opcional paralelo_id para filtrar por paralelo.
  Future<EstudiantesTablaResponse> getTabla({int? paraleloId}) async {
    final queryParams = <String, dynamic>{};
    if (paraleloId != null) queryParams['paralelo_id'] = paraleloId;
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.estudiantesTabla,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return EstudiantesTablaResponse.fromJson(response.data!);
  }

  /// Obtiene el perfil completo de un estudiante.
  /// GET /api/v1/estudiantes/:id/perfil
  Future<EstudiantePerfilResponse> getPerfil(int estudianteId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.estudiantePerfil(estudianteId),
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return EstudiantePerfilResponse.fromJson(response.data!);
  }

  /// Lista acciones de seguimiento (GET /acciones?estudiante_id=&limite=).
  Future<AccionesListResponse> getAcciones({
    required int estudianteId,
    int limite = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.acciones,
      queryParameters: {
        'estudiante_id': estudianteId,
        'limite': limite,
      },
    );
    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }
    return AccionesListResponse.fromJson(response.data!);
  }

  /// Crea una acción de seguimiento para un estudiante.
  /// POST /api/v1/acciones — body: descripcion, fecha (YYYY-MM-DD), estudiante_id.
  Future<void> postCrearAccion({
    required String descripcion,
    required String fecha,
    required int estudianteId,
  }) async {
    await _dio.post<dynamic>(
      ApiEndpoints.acciones,
      data: {
        'descripcion': descripcion,
        'fecha': fecha,
        'estudiante_id': estudianteId,
      },
    );
  }
}
