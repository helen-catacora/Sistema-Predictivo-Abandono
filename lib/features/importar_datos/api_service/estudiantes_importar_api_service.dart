import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/importacion_estudiantes_response.dart';

/// Servicio para POST /estudiantes/importar con archivo .xlsx en multipart/form-data.
class EstudiantesImportarApiService {
  EstudiantesImportarApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Envía el archivo Excel (.xlsx) en multipart/form-data con clave [archivo].
  Future<ImportacionEstudiantesResponse> postImportar(PlatformFile file) async {
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

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.estudiantesImportar,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    final data = response.data;
    if (data == null) {
      throw ArgumentError('Respuesta vacía del servidor');
    }
    return ImportacionEstudiantesResponse.fromJson(data);
  }
}
