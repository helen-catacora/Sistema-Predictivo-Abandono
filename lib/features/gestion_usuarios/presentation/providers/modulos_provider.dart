import 'package:flutter/foundation.dart';

import '../../repositories/usuarios_repository.dart';

/// Provider de módulos del sistema (GET /modulos).
/// Se carga una única vez al entrar al home para evitar múltiples peticiones.
class ModulosProvider extends ChangeNotifier {
  ModulosProvider({UsuariosRepository? repository})
      : _repository = repository ?? UsuariosRepository();

  final UsuariosRepository _repository;

  List<Map<String, dynamic>> _modulos = [];
  bool _loading = false;
  bool _loaded = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get modulos => List.unmodifiable(_modulos);
  bool get isLoading => _loading;
  bool get isLoaded => _loaded;
  String? get errorMessage => _errorMessage;

  /// Carga los módulos desde el backend. Solo realiza la petición si aún no se ha cargado.
  Future<void> loadModulos() async {
    if (_loaded || _loading) return;

    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _modulos = await _repository.getModulos();
      _loaded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) {
        print('ModulosProvider.loadModulos error: $e');
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
