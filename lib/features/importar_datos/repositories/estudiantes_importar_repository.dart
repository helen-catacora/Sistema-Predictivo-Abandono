import 'package:file_picker/file_picker.dart';

import '../api_service/estudiantes_importar_api_service.dart';
import '../data/models/importacion_estudiantes_response.dart';
import '../data/models/resumen_importaciones_response.dart';

/// Repositorio para importación de estudiantes desde Excel (POST /estudiantes/importar).
class EstudiantesImportarRepository {
  EstudiantesImportarRepository({
    EstudiantesImportarApiService? apiService,
  }) : _apiService = apiService ?? EstudiantesImportarApiService();

  final EstudiantesImportarApiService _apiService;

  Future<ImportacionEstudiantesResponse> enviarArchivo(PlatformFile file) =>
      _apiService.postImportar(file);

  Future<ResumenImportacionesResponse> getResumenImportaciones() =>
      _apiService.getResumenImportaciones();
}
