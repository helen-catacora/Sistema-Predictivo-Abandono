/// Devuelve el nombre del área según [areaId] (consistente con asistencia/reportes).
String nombreAreaParalelo(int areaId) {
  switch (areaId) {
    case 1:
      return 'Tecnologicas';
    case 2:
      return 'No Tecnologicas';
    default:
      return 'Área $areaId';
  }
}

/// Color del badge/pill por índice (para variar entre filas).
int colorIndexForParalelo(int index) => index % 4;
