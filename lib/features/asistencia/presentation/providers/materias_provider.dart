import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/materia_item.dart';
import '../../repositories/materias_repository.dart';

/// Estado de carga de materias.
enum MateriasStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider de materias para el dropdown de asistencia.
class MateriasProvider extends ChangeNotifier {
  MateriasProvider({MateriasRepository? repository})
      : _repository = repository ?? MateriasRepository();

  final MateriasRepository _repository;

  MateriasStatus _status = MateriasStatus.initial;
  List<MateriaItem> _materias = [];
  String? _errorMessage;

  MateriasStatus get status => _status;
  List<MateriaItem> get materias => List.unmodifiable(_materias);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == MateriasStatus.loading;
  bool get hasError => _status == MateriasStatus.error;

  /// Materias filtradas por area_id y semestre_id.
  List<MateriaItem> materiasPorAreaYSemestre(int areaId, int semestreId) {
    return _materias
        .where((m) => m.areaId == areaId && m.semestreId == semestreId)
        .toList();
  }

  /// Carga las materias desde el backend.
  Future<void> loadMaterias() async {
    _status = MateriasStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _materias = await _repository.getMaterias();
      _status = MateriasStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('MateriasProvider.loadMaterias error: $e\n$st');
      _status = MateriasStatus.error;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          msg = (data['detail'] ?? data['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar materias';
      _materias = [];
    }
    notifyListeners();
  }
}
