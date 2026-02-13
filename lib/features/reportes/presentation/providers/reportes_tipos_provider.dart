import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/reporte_tipo_item.dart';
import '../../repositories/reportes_repository.dart';

enum ReportesTiposStatus { initial, loading, success, error }

/// Provider de tipos de reportes (GET /reportes/tipos).
class ReportesTiposProvider extends ChangeNotifier {
  ReportesTiposProvider({ReportesRepository? repository})
    : _repository = repository ?? ReportesRepository();

  final ReportesRepository _repository;

  ReportesTiposStatus _status = ReportesTiposStatus.initial;
  List<ReporteTipoItem> _tipos = [];
  String? _errorMessage;

  ReportesTiposStatus get status => _status;
  List<ReporteTipoItem> get tipos => List.unmodifiable(_tipos);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ReportesTiposStatus.loading;
  bool get hasError => _status == ReportesTiposStatus.error;
  bool get hasData => _tipos.isNotEmpty;

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  /// Construye el body y llama al API para generar el PDF.
  /// Para por_paralelo debe pasarse [paraleloId]; para individual, [estudianteId].
  Future<Uint8List?> generarReporte(
    ReporteTipoItem item, {
    int? paraleloId,
    int? estudianteId,
  }) async {
    final body = <String, dynamic>{"tipo": item.tipo};
    if (item.requiereParalelo && paraleloId != null) {
      body["paralelo_id"] = paraleloId;
    }
    if (item.requiereEstudiante && estudianteId != null) {
      body["estudiante_id"] = estudianteId;
    }

    if (item.requiereParalelo && paraleloId == null) {
      throw ArgumentError('Se requiere paralelo_id para este reporte');
    }
    if (item.requiereEstudiante && estudianteId == null) {
      throw ArgumentError('Se requiere estudiante_id para este reporte');
    }

    _isGenerating = true;
    notifyListeners();

    try {
      final bytes = await _repository.generar(body);
      _isGenerating = false;
      notifyListeners();
      return bytes;
    } catch (e, st) {
      debugPrint('ReportesTiposProvider.generarReporte error: $e\n$st');
      _isGenerating = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadTipos() async {
    _status = ReportesTiposStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getTipos();
      _tipos = response.tipos;
      _status = ReportesTiposStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('ReportesTiposProvider.loadTipos error: $e\n$st');
      _status = ReportesTiposStatus.error;
      String? msg;
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          msg = (responseData['detail'] ?? responseData['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar tipos de reportes';
      _tipos = [];
    }
    notifyListeners();
  }
}
