import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../data/models/gestion_item.dart';
import '../providers/gestiones_provider.dart';
import 'gestiones_crear_dialog.dart';
import 'gestiones_ventanas_dialog.dart';

class GestionesListSection extends StatelessWidget {
  const GestionesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GestionesProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = Responsive.contentPadding(constraints.maxWidth);

        return Padding(
          padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, padding.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                top: BorderSide(color: AppColors.gray002855, width: 4),
                left: BorderSide(color: AppColors.greyE2E8F0),
                right: BorderSide(color: AppColors.greyE2E8F0),
                bottom: BorderSide(color: AppColors.greyE2E8F0),
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título de sección con barra lateral
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.gray002855,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Listado de Gestiones',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkBlue1E293B,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.gray002855,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(
                          'Nueva Gestión',
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () => showCrearGestionDialog(context),
                      ),
                    ],
                  ),
                ),

                // Contenido
                if (provider.status == GestionesStatus.loading)
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.status == GestionesStatus.error)
                  _ErrorView(message: provider.errorMessage ?? 'Error al cargar gestiones')
                else if (provider.gestiones.isEmpty)
                  _EmptyView()
                else
                  _GestionesTable(gestiones: provider.gestiones),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GestionesTable extends StatelessWidget {
  const _GestionesTable({required this.gestiones});
  final List<GestionItem> gestiones;

  static const double _acciones = 100;
  static const double _gap = 16;
  static const int _flexNombre = 2;
  static const int _flexPeriodo = 3;
  static const int _flexEstado = 2;
  static const int _flexRegistro = 3;
  static const int _totalFlex = _flexNombre + _flexPeriodo + _flexEstado + _flexRegistro;

  /// Calcula el ancho de cada columna proporcional dado el ancho total disponible.
  /// Se descuenta el padding horizontal de la fila (16 × 2 = 32) y los 4 gaps de 16px.
  static Map<String, double> _widths(double total) {
    final available = total - _acciones - (_gap * 4) - 32;
    final unit = available / _totalFlex;
    return {
      'nombre': unit * _flexNombre,
      'periodo': unit * _flexPeriodo,
      'estado': unit * _flexEstado,
      'registro': unit * _flexRegistro,
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _widths(constraints.maxWidth);
        return Column(
          children: [
            // Encabezado navy — sin padding extra, _TableRow ya provee el suyo
            _TableRow(
              widths: w,
              rowColor: AppColors.gray002855,
              nombre: _hText('NOMBRE'),
              periodo: _hText('PERÍODO ACADÉMICO'),
              estado: _hText('ESTADO'),
              registro: _hText('REGISTRO ESTUDIANTES'),
              acciones: _hText('ACCIONES', center: true),
            ),
            // Filas de datos
            ...gestiones.asMap().entries.map((entry) => Column(
                  children: [
                    Divider(height: 1, color: AppColors.greyE2E8F0),
                    _GestionRow(gestion: entry.value, isEven: entry.key.isEven, widths: w),
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget _hText(String t, {bool center = false}) => Text(
        t,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Colors.white),
      );
}

/// Fila genérica con anchos fijos calculados por el padre.
class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.widths,
    required this.nombre,
    required this.periodo,
    required this.estado,
    required this.registro,
    required this.acciones,
    this.rowColor,
  });

  final Map<String, double> widths;
  final Widget nombre;
  final Widget periodo;
  final Widget estado;
  final Widget registro;
  final Widget acciones;
  final Color? rowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: widths['nombre']!, child: nombre),
          const SizedBox(width: 16),
          SizedBox(width: widths['periodo']!, child: periodo),
          const SizedBox(width: 16),
          SizedBox(width: widths['estado']!, child: estado),
          const SizedBox(width: 16),
          SizedBox(width: widths['registro']!, child: registro),
          const SizedBox(width: 16),
          SizedBox(width: 100, child: acciones),
        ],
      ),
    );
  }
}

class _GestionRow extends StatelessWidget {
  const _GestionRow({required this.gestion, required this.isEven, required this.widths});
  final GestionItem gestion;
  final bool isEven;
  final Map<String, double> widths;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    final provider = context.watch<GestionesProvider>();

    String ventana(DateTime? ini, DateTime? fin) {
      if (ini == null || fin == null) return '—';
      return '${fmt.format(ini)} – ${fmt.format(fin)}';
    }

    final estadoWidget = gestion.activa
        ? Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Activa',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.green15803D),
              ),
            ),
          )
        : Text('Inactiva',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey64748B));

    final accionesWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!gestion.activa)
          SizedBox(
            height: 32,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green16A34A,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: provider.isActivating
                  ? null
                  : () async {
                      final ok =
                          await context.read<GestionesProvider>().activarGestion(gestion.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(ok
                            ? 'Gestión "${gestion.nombre}" activada'
                            : (context.read<GestionesProvider>().errorMessage ?? 'Error')),
                      ));
                    },
              child: provider.isActivating
                  ? const SizedBox(
                      width: 14, height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Activar',
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        const SizedBox(width: 4),
        Tooltip(
          message: 'Configurar período de registro',
          child: IconButton(
            icon: const Icon(Icons.event_available_outlined,
                size: 22, color: AppColors.gray002855),
            onPressed: () => showVentanaDialog(context, gestion),
          ),
        ),
      ],
    );

    return _TableRow(
      widths: widths,
      rowColor: isEven ? const Color(0xFFF8FAFC) : Colors.white,
      nombre: Text(gestion.nombre,
          style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkBlue1E293B)),
      periodo: Text(
          '${fmt.format(gestion.fechaInicio)} – ${fmt.format(gestion.fechaFin)}',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.black334155)),
      estado: estadoWidget,
      registro: Text(
          ventana(gestion.fechaInicioRegistroEstudiantes, gestion.fechaFinRegistroEstudiantes),
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.black334155)),
      acciones: accionesWidget,
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.date_range_outlined, size: 52, color: AppColors.grayMedium),
            const SizedBox(height: 14),
            Text('No hay gestiones académicas',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.grayMedium)),
            const SizedBox(height: 6),
            Text('Crea una nueva gestión para comenzar.',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Text(message, style: GoogleFonts.inter(fontSize: 13, color: AppColors.redDC2626)),
      ),
    );
  }
}
