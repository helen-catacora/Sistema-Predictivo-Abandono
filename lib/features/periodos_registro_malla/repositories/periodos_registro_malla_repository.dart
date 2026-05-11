import '../api_service/periodos_registro_malla_api_service.dart';
import '../data/models/periodo_registro_malla_item.dart';

class PeriodosRegistroMallaRepository {
  PeriodosRegistroMallaRepository({PeriodosRegistroMallaApiService? apiService})
      : _api = apiService ?? PeriodosRegistroMallaApiService();

  final PeriodosRegistroMallaApiService _api;

  Future<List<PeriodoRegistroMallaItem>> getPeriodos() => _api.getPeriodos();

  Future<PeriodoRegistroMallaItem> createPeriodo({
    required String descripcion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) =>
      _api.createPeriodo(
        descripcion: descripcion,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

  Future<PeriodoRegistroMallaItem> activar(int id) => _api.activar(id);

  Future<PeriodoRegistroMallaItem> desactivar(int id) => _api.desactivar(id);
}
