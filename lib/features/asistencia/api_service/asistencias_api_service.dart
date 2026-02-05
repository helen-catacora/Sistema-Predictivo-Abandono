import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/asistencia_dia_response.dart';
import '../data/models/asistencia_save_request.dart';

/// Servicio de API para asistencias.
class AsistenciasApiService {
  AsistenciasApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene las asistencias del día por materia y paralelo.
  /// GET /api/v1/asistencias/dia?materia_id=X&paralelo_id=Y
  Future<AsistenciaDiaResponse> getAsistenciasDia({
    required int materiaId,
    required int paraleloId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.asistenciasDia,
      queryParameters: {
        'materia_id': materiaId,
        'paralelo_id': paraleloId,
      },
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return AsistenciaDiaResponse.fromJson(response.data!);
  }

  /// Guarda las asistencias del día.
  /// POST /api/v1/asistencias/dia?materia_id=X&paralelo_id=Y
  Future<void> postAsistenciasDia({
    required int materiaId,
    required int paraleloId,
    required AsistenciaSaveRequest body,
  }) async {
    await _dio.post<void>(
      ApiEndpoints.asistenciasDia,
      queryParameters: {
        'materia_id': materiaId,
        'paralelo_id': paraleloId,
      },
      data: body.toJson(),
    );
  }
}
