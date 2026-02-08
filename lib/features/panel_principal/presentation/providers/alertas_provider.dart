import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/alertas_response.dart';
import '../../repositories/alertas_repository.dart';

enum AlertasStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider del listado de alertas (GET /alertas).
class AlertasProvider extends ChangeNotifier {
  AlertasProvider({AlertasRepository? repository})
      : _repository = repository ?? AlertasRepository();

  final AlertasRepository _repository;

  AlertasStatus _status = AlertasStatus.initial;
  AlertasResponse? _data;
  String? _errorMessage;

  AlertasStatus get status => _status;
  AlertasResponse? get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AlertasStatus.loading;
  bool get hasError => _status == AlertasStatus.error;
  bool get hasData => _data != null;

  int get total => _data?.total ?? 0;
  int get totalActivas => _data?.totalActivas ?? 0;
  int get totalCriticas => _data?.totalCriticas ?? 0;
  List<AlertaItem> get alertas => _data?.alertas ?? [];

  /// Alertas prioritarias para la sección "Alertas Críticas" (críticas y altas primero, hasta N).
  List<AlertaItem> get alertasPrioritarias {
    final list = alertas;
    if (list.isEmpty) return [];
    final critico = list.where((a) => _esCritico(a.nivel)).toList();
    final alto = list.where((a) => _esAlto(a.nivel)).toList();
    final resto = list.where((a) => !_esCritico(a.nivel) && !_esAlto(a.nivel)).toList();
    return [...critico, ...alto, ...resto];
  }

  static bool _esCritico(String nivel) {
    final n = nivel.toLowerCase();
    return n.contains('critico') || n.contains('crítico');
  }

  static bool _esAlto(String nivel) {
    final n = nivel.toLowerCase();
    return n == 'alto' || n.contains('alto');
  }

  Future<void> loadAlertas() async {
    _status = AlertasStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await _repository.getAlertas();
      _status = AlertasStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('AlertasProvider.loadAlertas error: $e\n$st');
      _status = AlertasStatus.error;
      String? msg;
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          msg = (responseData['detail'] ?? responseData['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar alertas';
      _data = null;
    }
    notifyListeners();
  }
}
