import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/estudiante_perfil_response.dart';
import 'perfil_section_card.dart';

/// Card con datos sociodemográficos (y datos básicos como edad, género).
class PerfilDatosSociodemograficos extends StatelessWidget {
  const PerfilDatosSociodemograficos({
    super.key,
    this.datos,
    required this.datosBasicos,
  });

  final DatosSociodemograficosPerfil? datos;
  final DatosBasicosPerfil datosBasicos;

  static String _v(dynamic v) => v != null && v.toString().isNotEmpty ? v.toString() : '-';

  @override
  Widget build(BuildContext context) {
    return PerfilSectionCard(
      icon: Icons.analytics_outlined,
      title: 'Datos Sociodemográficos',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('EDAD', datosBasicos.edad != null ? '${datosBasicos.edad} años' : _v(datos?.fechaNacimiento)),
                  const SizedBox(height: 10),
                  _row('TIPO DE COLEGIO', _v(datos?.tipoColegio)),
                  const SizedBox(height: 10),
                  _row('TRABAJA', _v(datos?.ocupacionLaboral)),
                  const SizedBox(height: 10),
                  _row('GRADO', _v(datos?.grado)),
                  const SizedBox(height: 10),
                  _row('MODALIDAD DE INGRESO', _v(datos?.modalidadIngreso)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('GÉNERO', _v(datosBasicos.genero)),
                  const SizedBox(height: 10),
                  _row('BECA/APOYO ECONÓMICO', _v(datos?.apoyoEconomico)),
                  const SizedBox(height: 10),
                  _row('CON QUIÉN VIVE', _v(datos?.conQuienVive)),
                  const SizedBox(height: 10),
                  _row('ESTRATO SOCIOECONÓMICO', _v(datos?.estratoSocioeconomico)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.navyMedium,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
