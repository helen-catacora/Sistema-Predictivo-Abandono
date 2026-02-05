import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/paralelo_item.dart';
import '../../repositories/paralelos_repository.dart';

/// Estado de carga de paralelos.
enum ParalelosStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider de paralelos para el dropdown de asistencia.
class ParalelosProvider extends ChangeNotifier {
  ParalelosProvider({ParalelosRepository? repository})
      : _repository = repository ?? ParalelosRepository();

  final ParalelosRepository _repository;

  ParalelosStatus _status = ParalelosStatus.initial;
  List<ParaleloItem> _paralelos = [];
  String? _errorMessage;

  ParalelosStatus get status => _status;
  List<ParaleloItem> get paralelos => List.unmodifiable(_paralelos);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ParalelosStatus.loading;
  bool get hasError => _status == ParalelosStatus.error;

  /// Carga los paralelos desde el backend.
  Future<void> loadParalelos() async {
    _status = ParalelosStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _paralelos = await _repository.getParalelos();
      _status = ParalelosStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('ParalelosProvider.loadParalelos error: $e\n$st');
      _status = ParalelosStatus.error;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          msg = (data['detail'] ?? data['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar paralelos';
      _paralelos = [];
    }
    notifyListeners();
  }
}
