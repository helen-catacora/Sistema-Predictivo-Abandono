/// Respuesta de GET /estudiantes/:id/perfil.
class EstudiantePerfilResponse {
  EstudiantePerfilResponse({
    required this.datosBasicos,
    this.datosSociodemograficos,
    this.desempenioAcademico,
    this.riesgoYPrediccion,
    this.alertas,
    this.acciones = const [],
  });

  final DatosBasicosPerfil datosBasicos;
  final DatosSociodemograficosPerfil? datosSociodemograficos;
  final DesempenioAcademicoPerfil? desempenioAcademico;
  final RiesgoYPrediccionPerfil? riesgoYPrediccion;
  final AlertasPerfil? alertas;
  final List<AccionPerfil> acciones;

  factory EstudiantePerfilResponse.fromJson(Map<String, dynamic> json) {
    return EstudiantePerfilResponse(
      datosBasicos: DatosBasicosPerfil.fromJson(
        json['datos_basicos'] as Map<String, dynamic>? ?? {},
      ),
      datosSociodemograficos: json['datos_sociodemograficos'] != null
          ? DatosSociodemograficosPerfil.fromJson(
              json['datos_sociodemograficos'] as Map<String, dynamic>,
            )
          : null,
      desempenioAcademico: json['desempenio_academico'] != null
          ? DesempenioAcademicoPerfil.fromJson(
              json['desempenio_academico'] as Map<String, dynamic>,
            )
          : null,
      riesgoYPrediccion: json['riesgo_y_prediccion'] != null
          ? RiesgoYPrediccionPerfil.fromJson(
              json['riesgo_y_prediccion'] as Map<String, dynamic>,
            )
          : null,
      alertas: json['alertas'] != null
          ? AlertasPerfil.fromJson(json['alertas'] as Map<String, dynamic>)
          : null,
      acciones:
          (json['acciones'] as List<dynamic>?)
              ?.map((e) => AccionPerfil.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DatosBasicosPerfil {
  DatosBasicosPerfil({
    required this.id,
    required this.codigoEstudiante,
    required this.nombreCompleto,
    required this.mallaCurricular,
    this.edad,
    this.genero,
    this.carrera,
    this.paralelo,
  });

  final int id;
  final String codigoEstudiante;
  final String nombreCompleto;
  final int? edad;
  final String? genero;
  final String? carrera;
  final ParaleloPerfil? paralelo;
  final String mallaCurricular;

  factory DatosBasicosPerfil.fromJson(Map<String, dynamic> json) {
    return DatosBasicosPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      codigoEstudiante: json['codigo_estudiante'] as String? ?? '',
      nombreCompleto: json['nombre_completo'] as String? ?? '',
      edad: (json['edad'] as num?)?.toInt(),
      genero: json['genero'] as String?,
      carrera: json['carrera'] as String?,
      paralelo: json['paralelo'] != null
          ? ParaleloPerfil.fromJson(json['paralelo'] as Map<String, dynamic>)
          : null,
      mallaCurricular:
          json['nombre_malla'] as String? ?? 'SIN MALLA CURRICULAR',
    );
  }
}

class ParaleloPerfil {
  ParaleloPerfil({
    required this.id,
    required this.nombre,
    this.semestre,
    this.encargado,
  });

  final int id;
  final String nombre;
  final String? semestre;
  final EncargadoPerfil? encargado;

  factory ParaleloPerfil.fromJson(Map<String, dynamic> json) {
    return ParaleloPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      semestre: json['semestre'] as String?,
      encargado: json['encargado'] != null
          ? EncargadoPerfil.fromJson(json['encargado'] as Map<String, dynamic>)
          : null,
    );
  }
}

class EncargadoPerfil {
  EncargadoPerfil({required this.id, required this.nombre});

  final int id;
  final String nombre;

  factory EncargadoPerfil.fromJson(Map<String, dynamic> json) {
    return EncargadoPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
    );
  }
}

class DatosSociodemograficosPerfil {
  DatosSociodemograficosPerfil({
    this.fechaNacimiento,
    this.grado,
    this.estratoSocioeconomico,
    this.ocupacionLaboral,
    this.conQuienVive,
    this.apoyoEconomico,
    this.modalidadIngreso,
    this.tipoColegio,
  });

  final String? fechaNacimiento;
  final String? grado;
  final String? estratoSocioeconomico;
  final String? ocupacionLaboral;
  final String? conQuienVive;
  final String? apoyoEconomico;
  final String? modalidadIngreso;
  final String? tipoColegio;

  factory DatosSociodemograficosPerfil.fromJson(Map<String, dynamic> json) {
    return DatosSociodemograficosPerfil(
      fechaNacimiento: json['fecha_nacimiento'] as String?,
      grado: json['grado'] as String?,
      estratoSocioeconomico: json['estrato_socioeconomico'] as String?,
      ocupacionLaboral: json['ocupacion_laboral'] as String?,
      conQuienVive: json['con_quien_vive'] as String?,
      apoyoEconomico: json['apoyo_economico'] as String?,
      modalidadIngreso: json['modalidad_ingreso'] as String?,
      tipoColegio: json['tipo_colegio'] as String?,
    );
  }
}

class DesempenioAcademicoPerfil {
  DesempenioAcademicoPerfil({
    this.porcentajeAsistenciaGeneral = 0,
    this.faltasConsecutivas = 0,
    this.materias = const [],
  });

  final double porcentajeAsistenciaGeneral;
  final int faltasConsecutivas;
  final List<MateriaDesempenioPerfil> materias;

  factory DesempenioAcademicoPerfil.fromJson(Map<String, dynamic> json) {
    return DesempenioAcademicoPerfil(
      porcentajeAsistenciaGeneral:
          (json['porcentaje_asistencia_general'] as num?)?.toDouble() ?? 0,
      faltasConsecutivas: (json['faltas_consecutivas'] as num?)?.toInt() ?? 0,
      materias:
          (json['materias'] as List<dynamic>?)
              ?.map(
                (e) =>
                    MateriaDesempenioPerfil.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class MateriaDesempenioPerfil {
  MateriaDesempenioPerfil({
    required this.materiaId,
    required this.nombre,
    this.gestionAcademica,
    this.porcentajeAsistencia = 0,
    this.asistencias,
  });

  final int materiaId;
  final String nombre;
  final String? gestionAcademica;
  final double porcentajeAsistencia;
  final AsistenciasCountPerfil? asistencias;

  factory MateriaDesempenioPerfil.fromJson(Map<String, dynamic> json) {
    return MateriaDesempenioPerfil(
      materiaId: (json['materia_id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      gestionAcademica: json['gestion_academica'] as String?,
      porcentajeAsistencia:
          (json['porcentaje_asistencia'] as num?)?.toDouble() ?? 0,
      asistencias: json['asistencias'] != null
          ? AsistenciasCountPerfil.fromJson(
              json['asistencias'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class AsistenciasCountPerfil {
  AsistenciasCountPerfil({
    this.presentes = 0,
    this.ausentes = 0,
    this.justificados = 0,
  });

  final int presentes;
  final int ausentes;
  final int justificados;

  factory AsistenciasCountPerfil.fromJson(Map<String, dynamic> json) {
    return AsistenciasCountPerfil(
      presentes: (json['presentes'] as num?)?.toInt() ?? 0,
      ausentes: (json['ausentes'] as num?)?.toInt() ?? 0,
      justificados: (json['justificados'] as num?)?.toInt() ?? 0,
    );
  }
}

class RiesgoYPrediccionPerfil {
  RiesgoYPrediccionPerfil({this.prediccionActual, this.historial = const []});

  final PrediccionActualPerfil? prediccionActual;
  final List<HistorialPrediccionPerfil> historial;

  factory RiesgoYPrediccionPerfil.fromJson(Map<String, dynamic> json) {
    return RiesgoYPrediccionPerfil(
      prediccionActual: json['prediccion_actual'] != null
          ? PrediccionActualPerfil.fromJson(
              json['prediccion_actual'] as Map<String, dynamic>,
            )
          : null,
      historial:
          (json['historial'] as List<dynamic>?)
              ?.map(
                (e) => HistorialPrediccionPerfil.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class PrediccionActualPerfil {
  PrediccionActualPerfil({
    required this.id,
    this.probabilidadAbandono = 0,
    this.nivelRiesgo,
    this.clasificacion,
    this.fechaPrediccion,
    this.tipo,
    this.versionModelo,
    this.featuresUtilizadas = const {},
  });

  final int id;
  final double probabilidadAbandono;
  final String? nivelRiesgo;
  final String? clasificacion;
  final String? fechaPrediccion;
  final String? tipo;
  final String? versionModelo;
  final Map<String, dynamic> featuresUtilizadas;

  factory PrediccionActualPerfil.fromJson(Map<String, dynamic> json) {
    final features = json['features_utilizadas'] as Map<String, dynamic>?;
    return PrediccionActualPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      probabilidadAbandono:
          (json['probabilidad_abandono'] as num?)?.toDouble() ?? 0,
      nivelRiesgo: json['nivel_riesgo'] as String?,
      clasificacion: json['clasificacion'] as String?,
      fechaPrediccion: json['fecha_prediccion'] as String?,
      tipo: json['tipo'] as String?,
      versionModelo: json['version_modelo'] as String?,
      featuresUtilizadas: features != null
          ? Map<String, dynamic>.from(features)
          : {},
    );
  }
}

class HistorialPrediccionPerfil {
  HistorialPrediccionPerfil({
    required this.id,
    this.fechaPrediccion,
    this.probabilidadAbandono = 0,
    this.nivelRiesgo,
  });

  final int id;
  final String? fechaPrediccion;
  final double probabilidadAbandono;
  final String? nivelRiesgo;

  factory HistorialPrediccionPerfil.fromJson(Map<String, dynamic> json) {
    return HistorialPrediccionPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fechaPrediccion: json['fecha_prediccion'] as String?,
      probabilidadAbandono:
          (json['probabilidad_abandono'] as num?)?.toDouble() ?? 0,
      nivelRiesgo: json['nivel_riesgo'] as String?,
    );
  }
}

class AlertasPerfil {
  AlertasPerfil({this.activas = const [], this.historial = const []});

  final List<AlertaItemPerfil> activas;
  final List<AlertaItemPerfil> historial;

  factory AlertasPerfil.fromJson(Map<String, dynamic> json) {
    return AlertasPerfil(
      activas:
          (json['activas'] as List<dynamic>?)
              ?.map((e) => AlertaItemPerfil.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      historial:
          (json['historial'] as List<dynamic>?)
              ?.map((e) => AlertaItemPerfil.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AlertaItemPerfil {
  AlertaItemPerfil({
    required this.id,
    this.tipo,
    this.nivel,
    this.titulo,
    this.descripcion,
    this.fechaCreacion,
    this.estado,
    this.faltasConsecutivas,
    this.fechaResolucion,
    this.observacionResolucion,
  });

  final int id;
  final String? tipo;
  final String? nivel;
  final String? titulo;
  final String? descripcion;
  final String? fechaCreacion;
  final String? estado;
  final int? faltasConsecutivas;
  final String? fechaResolucion;
  final String? observacionResolucion;

  factory AlertaItemPerfil.fromJson(Map<String, dynamic> json) {
    return AlertaItemPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tipo: json['tipo'] as String?,
      nivel: json['nivel'] as String?,
      titulo: json['titulo'] as String?,
      descripcion: json['descripcion'] as String?,
      fechaCreacion: json['fecha_creacion'] as String?,
      estado: json['estado'] as String?,
      faltasConsecutivas: (json['faltas_consecutivas'] as num?)?.toInt(),
      fechaResolucion: json['fecha_resolucion'] as String?,
      observacionResolucion: json['observacion_resolucion'] as String?,
    );
  }
}

class AccionPerfil {
  AccionPerfil({
    required this.id,
    this.descripcion,
    this.fecha,
    this.prediccionId,
  });

  final int id;
  final String? descripcion;
  final String? fecha;
  final int? prediccionId;

  factory AccionPerfil.fromJson(Map<String, dynamic> json) {
    return AccionPerfil(
      id: (json['id'] as num?)?.toInt() ?? 0,
      descripcion: json['descripcion'] as String?,
      fecha: json['fecha'] as String?,
      prediccionId: (json['prediccion_id'] as num?)?.toInt(),
    );
  }
}
