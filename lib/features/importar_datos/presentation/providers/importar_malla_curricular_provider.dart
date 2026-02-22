import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/importacion_malla_response.dart';
import '../../repositories/malla_curricular_importar_repository.dart';

/// Provider para la importación de malla curricular (POST /malla-curricular/importar).
class ImportarMallaCurricularProvider extends ChangeNotifier {
  ImportarMallaCurricularProvider({
    MallaCurricularImportarRepository? repository,
  }) : _repository = repository ?? MallaCurricularImportarRepository();

  final MallaCurricularImportarRepository _repository;

  bool _isImporting = false;
  String? _errorMessage;
  ImportacionMallaResponse? _lastResponse;

  bool get isImporting => _isImporting;
  String? get errorMessage => _errorMessage;
  ImportacionMallaResponse? get lastResponse => _lastResponse;

  /// Envía el archivo .xlsx y nombre_malla al endpoint de importación.
  Future<ImportacionMallaResponse?> enviarArchivo({
    required PlatformFile file,
    required String nombreMalla,
  }) async {
    if (file.bytes == null && (file.path == null || file.path!.isEmpty)) {
      _errorMessage = 'No se pudo leer el archivo';
      notifyListeners();
      return null;
    }
    if (nombreMalla.trim().isEmpty) {
      _errorMessage = 'Debe indicar el nombre de la malla curricular';
      notifyListeners();
      return null;
    }

    _isImporting = true;
    _errorMessage = null;
    _lastResponse = null;
    notifyListeners();

    try {
      final response = await _repository.enviarArchivo(
        file: file,
        nombreMalla: nombreMalla.trim(),
      );
      _isImporting = false;
      _errorMessage = null;
      _lastResponse = response;
      notifyListeners();
      return response;
    } catch (e, st) {
      debugPrint(
          'ImportarMallaCurricularProvider.enviarArchivo error: $e\n$st');
      _isImporting = false;
      _lastResponse = null;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          final detail = data['detail'];
          if (detail is String) {
            msg = detail;
          } else if (detail is List && detail.isNotEmpty && detail[0] is Map) {
            msg = (detail[0] as Map)['msg']?.toString();
          }
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al importar. Intente de nuevo.';
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
