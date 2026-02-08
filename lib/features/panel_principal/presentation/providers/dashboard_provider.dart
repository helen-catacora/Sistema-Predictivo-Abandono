import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/dashboard_response.dart';
import '../../repositories/dashboard_repository.dart';

enum DashboardStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider del dashboard de predicciones (resumen, distribución riesgo, paralelos).
class DashboardProvider extends ChangeNotifier {
  DashboardProvider({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository();

  final DashboardRepository _repository;

  DashboardStatus _status = DashboardStatus.initial;
  DashboardResponse? _data;
  String? _errorMessage;

  DashboardStatus get status => _status;
  DashboardResponse? get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == DashboardStatus.loading;
  bool get hasError => _status == DashboardStatus.error;
  bool get hasData => _data != null;

  ResumenGeneral? get resumenGeneral => _data?.resumenGeneral;
  List<DistribucionRiesgoItem> get distribucionRiesgo =>
      _data?.distribucionRiesgo ?? [];
  List<DistribucionPorParaleloItem> get distribucionPorParalelo =>
      _data?.distribucionPorParalelo ?? [];

  Future<void> loadDashboard() async {
    _status = DashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await _repository.getDashboard();
      _status = DashboardStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('DashboardProvider.loadDashboard error: $e\n$st');
      _status = DashboardStatus.error;
      String? msg;
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          msg = (responseData['detail'] ?? responseData['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar el dashboard';
      _data = null;
    }
    notifyListeners();
  }
}
