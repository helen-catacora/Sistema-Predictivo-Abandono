import 'package:shared_preferences/shared_preferences.dart';

/// Almacenamiento del token de autenticación en caché local.
class TokenStorage {
  TokenStorage._();

  static const String _keyAccessToken = 'access_token';
  static const String _keyRolId = 'rol_id';

  static SharedPreferences? _prefs;
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError(
        'TokenStorage no inicializado. Llame a TokenStorage.ensureInit() antes de usar.',
      );
    }
    return _prefs!;
  }

  /// Inicializa SharedPreferences. Debe llamarse al arrancar la app.
  static Future<void> ensureInit() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Guarda el token y rol_id.
  static Future<void> saveToken(String accessToken, int rolId) async {
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setInt(_keyRolId, rolId);
  }

  /// Obtiene el token guardado.
  static String? getAccessToken() => prefs.getString(_keyAccessToken);

  /// Obtiene el rol_id guardado.
  static int? getRolId() => prefs.getInt(_keyRolId);

  /// Indica si hay sesión guardada.
  static bool get hasToken {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Elimina el token y rol_id.
  static Future<void> clear() async {
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRolId);
  }
}
