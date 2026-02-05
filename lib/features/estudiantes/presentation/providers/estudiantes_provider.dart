import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/estudiante_item.dart';
import '../../repositories/estudiantes_repository.dart';

/// Estado de carga de estudiantes.
enum EstudiantesStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider de la tabla de estudiantes.
class EstudiantesProvider extends ChangeNotifier {
  EstudiantesProvider({EstudiantesRepository? repository})
      : _repository = repository ?? EstudiantesRepository();

  final EstudiantesRepository _repository;

  EstudiantesStatus _status = EstudiantesStatus.initial;
  List<EstudianteItem> _estudiantes = [];
  String? _errorMessage;
  String _searchQuery = '';
  String? _carreraFilter;

  EstudiantesStatus get status => _status;
  List<EstudianteItem> get estudiantes => List.unmodifiable(_estudiantes);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == EstudiantesStatus.loading;
  bool get hasError => _status == EstudiantesStatus.error;
  String get searchQuery => _searchQuery;
  String? get carreraFilter => _carreraFilter;

  /// Lista de estudiantes filtrada por búsqueda y carrera.
  List<EstudianteItem> get filteredEstudiantes {
    var list = _estudiantes;
    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((e) {
        return e.nombreCompleto.toLowerCase().contains(query) ||
            e.codigoEstudiante.toLowerCase().contains(query) ||
            e.carrera.toLowerCase().contains(query);
      }).toList();
    }
    if (_carreraFilter != null && _carreraFilter!.isNotEmpty && _carreraFilter != 'todas') {
      list = list.where((e) => e.carrera == _carreraFilter).toList();
    }
    return list;
  }

  /// Carreras únicas para el dropdown.
  List<String> get carreras {
    final set = _estudiantes.map((e) => e.carrera).toSet();
    return set.toList()..sort();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setCarreraFilter(String? carrera) {
    if (_carreraFilter == carrera) return;
    _carreraFilter = (carrera == null || carrera == 'todas') ? null : carrera;
    notifyListeners();
  }

  /// Carga los estudiantes desde el backend.
  Future<void> loadEstudiantes() async {
    _status = EstudiantesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _estudiantes = await _repository.getTabla();
      _status = EstudiantesStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('EstudiantesProvider.loadEstudiantes error: $e\n$st');
      _status = EstudiantesStatus.error;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          msg = (data['detail'] ?? data['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar estudiantes';
      _estudiantes = [];
    }
    notifyListeners();
  }
}
