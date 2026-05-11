import '../api_service/gestiones_api_service.dart';
import '../data/models/gestion_item.dart';

class GestionesRepository {
  GestionesRepository({GestionesApiService? apiService})
      : _api = apiService ?? GestionesApiService();

  final GestionesApiService _api;

  Future<List<GestionItem>> getGestiones() => _api.getGestiones();

  Future<GestionItem> createGestion({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    DateTime? fechaInicioRegistroEstudiantes,
    DateTime? fechaFinRegistroEstudiantes,
  }) =>
      _api.createGestion(
        nombre: nombre,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        fechaInicioRegistroEstudiantes: fechaInicioRegistroEstudiantes,
        fechaFinRegistroEstudiantes: fechaFinRegistroEstudiantes,
      );

  Future<GestionItem> activarGestion(int id) => _api.activarGestion(id);

  Future<GestionItem> updateVentana({
    required int id,
    DateTime? fechaInicioRegistroEstudiantes,
    DateTime? fechaFinRegistroEstudiantes,
  }) =>
      _api.updateVentana(
        id: id,
        fechaInicioRegistroEstudiantes: fechaInicioRegistroEstudiantes,
        fechaFinRegistroEstudiantes: fechaFinRegistroEstudiantes,
      );
}
