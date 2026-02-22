import 'package:file_picker/file_picker.dart';

import '../api_service/malla_curricular_importar_api_service.dart';
import '../data/models/importacion_malla_response.dart';

/// Repositorio para importación de malla curricular desde Excel.
/// POST /malla-curricular/importar con multipart/form-data (archivo .xlsx, nombre_malla).
class MallaCurricularImportarRepository {
  MallaCurricularImportarRepository({
    MallaCurricularImportarApiService? apiService,
  }) : _apiService = apiService ?? MallaCurricularImportarApiService();

  final MallaCurricularImportarApiService _apiService;

  Future<ImportacionMallaResponse> enviarArchivo({
    required PlatformFile file,
    required String nombreMalla,
  }) =>
      _apiService.postImportar(file: file, nombreMalla: nombreMalla);
}
