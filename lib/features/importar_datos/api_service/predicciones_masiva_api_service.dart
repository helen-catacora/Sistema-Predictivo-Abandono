import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/resumen_importaciones_response.dart';

/// Servicio para POST /predicciones/masiva con archivo xlsx en multipart/form-data.
class PrediccionesMasivaApiService {
  PrediccionesMasivaApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Envía el archivo Excel (xlsx) en multipart/form-data.
  /// [file]: el archivo elegido con file_picker (usa path o bytes según plataforma).
  Future<void> postMasiva(PlatformFile file) async {
    final MultipartFile multipartFile;
    if (file.bytes != null && file.bytes!.isNotEmpty) {
      multipartFile = MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
      );
    } else if (file.path != null && file.path!.isNotEmpty) {
      multipartFile = await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      );
    } else {
      throw ArgumentError('El archivo no tiene datos (path o bytes)');
    }

    final formData = FormData.fromMap(<String, dynamic>{
      'archivo': multipartFile,
    });

    await _dio.post<dynamic>(
      ApiEndpoints.prediccionesMasiva,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  /// Obtiene el resumen de importaciones.
  /// GET /api/v1/predicciones/resumen-importaciones
  Future<ResumenImportacionesResponse> getResumenImportaciones() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.prediccionesResumenImportaciones,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return ResumenImportacionesResponse.fromJson(response.data!);
  }
}
