import 'package:flutter/foundation.dart';
import '../../data/models/login_response.dart';
import '../../repositories/auth_repository.dart';

/// Estado del proceso de login.
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Provider de autenticación.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  int? _rolId;
  /// Login exitoso pendiente de completar reCAPTCHA; no se guarda el token hasta completar.
  LoginResponse? _pendingLoginResponse;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int? get rolId => _rolId;
  bool get isAuthenticated => _repository.isLoggedIn;
  bool get isLoading => _status == AuthStatus.loading;

  /// Inicia sesión con email y contraseña.
  /// Si [persistSession] es false, no guarda el token (para mostrar reCAPTCHA primero).
  /// Luego hay que llamar [completeLogin] cuando el reCAPTCHA sea correcto.
  /// [recaptchaToken] token de reCAPTCHA v2 (solo Flutter web); el backend debe verificarlo con la SECRET KEY.
  Future<bool> login({
    required String email,
    required String password,
    String? recaptchaToken,
    bool persistSession = true,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _pendingLoginResponse = null;
    notifyListeners();

    try {
      final response = await _repository.login(
        email: email.trim(),
        password: password,
        recaptchaToken: recaptchaToken,
        saveToken: persistSession,
      );
      _rolId = response.rolId;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      if (!persistSession) {
        _pendingLoginResponse = response;
      }
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e, st) {
      debugPrint('AuthProvider.login error: $e\n$st');
      _status = AuthStatus.error;
      _errorMessage = 'Error inesperado. Intente nuevamente.';
      notifyListeners();
      return false;
    }
  }

  /// Completa el login guardando el token (tras reCAPTCHA correcto). Llama después de [login(..., persistSession: false)].
  Future<void> completeLogin() async {
    final pending = _pendingLoginResponse;
    if (pending == null) return;
    await _repository.saveTokenFromResponse(pending);
    _pendingLoginResponse = null;
    notifyListeners();
  }

  /// Cierra sesión.
  Future<void> logout() async {
    _pendingLoginResponse = null;
    await _repository.logout();
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    _rolId = null;
    notifyListeners();
  }

  /// Revisa si hay sesión guardada (al iniciar la app).
  void checkAuthStatus() {
    if (_repository.isLoggedIn) {
      _rolId = _repository.rolId;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Limpia el mensaje de error.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
