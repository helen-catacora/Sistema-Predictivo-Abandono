import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/reportes_historial_response.dart';
import '../data/models/reportes_tipos_response.dart';

/// Servicio de API para reportes.
class ReportesApiService {
  ReportesApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// GET /api/v1/reportes/tipos
  Future<ReportesTiposResponse> getTipos() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.reportesTipos,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return ReportesTiposResponse.fromJson(response.data!);
  }

  /// POST /api/v1/reportes/generar — body según tipo; respuesta es PDF (bytes).
  Future<Uint8List> generar(Map<String, dynamic> body) async {
    final response = await _dio.post<List<int>>(
      ApiEndpoints.reportesGenerar,
      data: body,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.data == null || response.data!.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return Uint8List.fromList(response.data!);
  }

  /// GET /api/v1/reportes/historial?page=1&page_size=20
  Future<ReportesHistorialResponse> getHistorial({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.reportesHistorial,
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return ReportesHistorialResponse.fromJson(response.data!);
  }
}
