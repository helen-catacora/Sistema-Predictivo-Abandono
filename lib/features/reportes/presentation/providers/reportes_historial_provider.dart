import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/reporte_historial_item.dart';
import '../../repositories/reportes_repository.dart';

enum ReportesHistorialStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider del historial de reportes (GET /reportes/historial).
class ReportesHistorialProvider extends ChangeNotifier {
  ReportesHistorialProvider({ReportesRepository? repository})
      : _repository = repository ?? ReportesRepository();

  final ReportesRepository _repository;

  ReportesHistorialStatus _status = ReportesHistorialStatus.initial;
  List<ReporteHistorialItem> _reportes = [];
  int _total = 0;
  int _page = 1;
  int _pageSize = 20;
  String? _errorMessage;

  ReportesHistorialStatus get status => _status;
  List<ReporteHistorialItem> get reportes => List.unmodifiable(_reportes);
  int get total => _total;
  int get page => _page;
  int get pageSize => _pageSize;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ReportesHistorialStatus.loading;
  bool get hasError => _status == ReportesHistorialStatus.error;

  Future<void> loadHistorial({int? page, int? pageSize}) async {
    final p = page ?? _page;
    final ps = pageSize ?? _pageSize;

    _status = ReportesHistorialStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getHistorial(page: p, pageSize: ps);
      _reportes = response.reportes;
      _total = response.total;
      _page = p;
      _pageSize = ps;
      _status = ReportesHistorialStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('ReportesHistorialProvider.loadHistorial error: $e\n$st');
      _status = ReportesHistorialStatus.error;
      String? msg;
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          msg = (responseData['detail'] ?? responseData['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar historial de reportes';
      _reportes = [];
    }
    notifyListeners();
  }
}
