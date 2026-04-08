import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/entrenamiento_historial_item.dart';

/// Tabla con el historial de entrenamientos del modelo ML.
class EntrenamientoHistorialTable extends StatelessWidget {
  const EntrenamientoHistorialTable({
    super.key,
    required this.historial,
    required this.isLoading,
  });

  final List<EntrenamientoHistorialItem> historial;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          top: BorderSide(color: Color(0xff002855), width: 4),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xff002855),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Historial de Entrenamientos',
                style: GoogleFonts.inter(
                  color: const Color(0xff1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 28 / 18,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (historial.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No se han realizado entrenamientos.',
                  style: GoogleFonts.inter(
                    color: const Color(0xff64748B),
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(AppColors.greyF1F5F9),
                columns: [
                  DataColumn(label: _headerText('Fecha')),
                  DataColumn(label: _headerText('Archivo')),
                  DataColumn(label: _headerText('Registros')),
                  DataColumn(label: _headerText('Modelo')),
                  DataColumn(label: _headerText('F1 Nuevo')),
                  DataColumn(label: _headerText('F1 Actual')),
                  DataColumn(label: _headerText('Estado')),
                  DataColumn(label: _headerText('Usuario')),
                ],
                rows: historial.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(
                      _formatDate(item.fechaInicio.toLocal()),
                      style: GoogleFonts.inter(fontSize: 12),
                    )),
                    DataCell(Text(
                      item.nombreArchivo,
                      style: GoogleFonts.inter(fontSize: 12),
                    )),
                    DataCell(Text(
                      '${item.totalRegistros}',
                      style: GoogleFonts.inter(fontSize: 12),
                    )),
                    DataCell(Text(
                      item.tipoMejorModelo ?? '-',
                      style: GoogleFonts.inter(fontSize: 12),
                    )),
                    DataCell(Text(
                      item.f1Nuevo?.toStringAsFixed(4) ?? '-',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _colorF1(item.f1Nuevo, item.f1Actual),
                      ),
                    )),
                    DataCell(Text(
                      item.f1Actual?.toStringAsFixed(4) ?? '-',
                      style: GoogleFonts.inter(fontSize: 12),
                    )),
                    DataCell(_estadoBadge(item.estado)),
                    DataCell(Text(
                      item.usuarioNombre,
                      style: GoogleFonts.inter(fontSize: 12),
                    )),
                  ]);
                }).toList(),
              ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xff1E293B),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$min';
  }

  Color _colorF1(double? f1Nuevo, double? f1Actual) {
    if (f1Nuevo == null) return const Color(0xff1E293B);
    if (f1Actual == null) return const Color(0xff1E293B);
    return f1Nuevo >= f1Actual ? AppColors.green16A34A : AppColors.redDC2626;
  }

  Widget _estadoBadge(String estado) {
    Color bg;
    Color fg;
    switch (estado) {
      case 'aceptado':
        bg = AppColors.green16A34A.withValues(alpha: 0.1);
        fg = AppColors.green16A34A;
        break;
      case 'rechazado':
        bg = AppColors.redDC2626.withValues(alpha: 0.1);
        fg = AppColors.redDC2626;
        break;
      case 'completado':
        bg = const Color(0xff002855).withValues(alpha: 0.1);
        fg = const Color(0xff002855);
        break;
      case 'error':
        bg = AppColors.redDC2626.withValues(alpha: 0.1);
        fg = AppColors.redDC2626;
        break;
      default:
        bg = AppColors.greyF1F5F9;
        fg = const Color(0xff64748B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado[0].toUpperCase() + estado.substring(1),
        style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
