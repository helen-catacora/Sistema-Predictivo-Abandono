import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tarjetas de resumen: Última Importación, Estadísticas, Campos Requeridos.
class ImportSummaryCards extends StatelessWidget {
  const ImportSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _LastImportCard(
          date: '15/01/2024',
          records: '1,248',
          fileName: 'estudiantes_2024.xlsx',
          success: true,
        ),
        const _StatisticsCard(),
      ],
    );
  }
}

class _LastImportCard extends StatelessWidget {
  const _LastImportCard({
    required this.date,
    required this.records,
    required this.fileName,
    required this.success,
  });

  final String date;
  final String records;
  final String fileName;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final backGroundColor = success
        ? const Color(0xffF0FDF4)
        : const Color(0xFFEAB308);
    final statusColor = success ? Color(0xff16A34A) : Color(0xFFEAB308);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xff22C55E), width: 4)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: backGroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.check_circle, color: statusColor, size: 20),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Última Importación',
                    style: GoogleFonts.inter(
                      color: Color(0xff1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 24 / 16,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    success ? 'Exitosa' : 'Con errores',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Fecha:',
                style: GoogleFonts.inter(
                  color: Color(0xff64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
              Spacer(),
              Text(
                date,
                style: GoogleFonts.inter(
                  color: Color(0xff334155),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Registros:',
                style: GoogleFonts.inter(
                  color: Color(0xff64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
              Spacer(),
              Text(
                records,
                style: GoogleFonts.inter(
                  color: Color(0xff334155),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Archivo:',
                style: GoogleFonts.inter(
                  color: Color(0xff64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
              Spacer(),
              Text(
                fileName,
                style: GoogleFonts.inter(
                  color: Color(0xff334155),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xffFFD60A), width: 4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffFEFCE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_graph_sharp,
                    color: Color(0xffFFD60A),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadísticas',
                      style: GoogleFonts.inter(
                        color: Color(0xff1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 24 / 16,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      'Total de Importaciones',
                      style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '47',
                    style: GoogleFonts.inter(
                      color: Color(0xff002855),
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 40 / 36,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'CARGAS REALIZADAS',
                    style: GoogleFonts.inter(
                      color: Color(0xff64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequiredFieldsCard extends StatelessWidget {
  const RequiredFieldsCard({super.key});

  static const _requiredFields = [
    'ID Estudiante',
    'Nombres Completos',
    'Apellidos',
    'Semestre / Nivel',
    'Promedio General',
    'Porcentaje Asistencia',
  ];

  static const _optionalFields = [
    'Email Institucional',
    'Teléfono',
    'Dirección',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.list_alt,
                    color: Color(0xff002855),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Campos Requeridos',
                  style: GoogleFonts.inter(
                    color: Color(0xff1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 24 / 16,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._requiredFields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_sharp, color: Color(0xff22C55E), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xff334155),
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(color: Color(0xffE2E8F0), height: 1),
            SizedBox(height: 32),
            Text(
              'CAMPOS OPCIONALES',
              style: GoogleFonts.inter(
                color: Color(0xff64748B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 16 / 12,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 12),
            ..._optionalFields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: Radio<String>(value: f),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xff64748B),
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
