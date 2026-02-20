import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/importar_predicciones_provider.dart';

/// Tarjetas de resumen: Última Importación, Estadísticas, Campos Requeridos.
class ImportSummaryCards extends StatefulWidget {
  const ImportSummaryCards({super.key});

  @override
  State<ImportSummaryCards> createState() => _ImportSummaryCardsState();
}

class _ImportSummaryCardsState extends State<ImportSummaryCards> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ImportarPrediccionesProvider>().loadResumenImportaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImportarPrediccionesProvider>(
      builder: (context, provider, _) {
        final resumen = provider.resumenImportaciones;
        final ultima = resumen?.ultimaImportacion;

        final date = ultima != null ? _formatearFecha(ultima.fechaCarga) : '—';
        final records = ultima != null
            ? ultima.cantidadRegistros.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]},',
              )
            : '—';
        final fileName = ultima?.nombreArchivo ?? '—';
        final total = resumen?.totalImportaciones ?? 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (provider.isLoadingResumen && resumen == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              _LastImportCard(
                date: date,
                records: records,
                fileName: fileName,
                tieneDatos: ultima != null,
              ),
            const SizedBox(height: 16),
            _StatisticsCard(total: total),
          ],
        );
      },
    );
  }

  String _formatearFecha(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _LastImportCard extends StatelessWidget {
  const _LastImportCard({
    required this.date,
    required this.records,
    required this.fileName,
    required this.tieneDatos,
  });

  final String date;
  final String records;
  final String fileName;
  final bool tieneDatos;

  @override
  Widget build(BuildContext context) {
    final backGroundColor =
        tieneDatos ? const Color(0xffF0FDF4) : const Color(0xffF1F5F9);
    final statusColor =
        tieneDatos ? Color(0xff16A34A) : Color(0xff64748B);
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
                    tieneDatos ? 'Exitosa' : 'Sin importaciones previas',
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
  const _StatisticsCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final totalStr = total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
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
                    totalStr,
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
    'Codigo del Estudiante',
    'Número de Materias',
    'Número de Materias Reprobadas',
    'Número de Materia en 2T',
    'Promedio General',  
    ];

  static const _optionalFields = [
    'Edad',
    'Grado del Estudiante',
    'Genero',
    'Estrato Socioeconomico',
    'Vive con',
    'Apoyo Economico',
    'Modalidad de Ingreso',
    'Tipo de Colegio al que pertenecio',
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
