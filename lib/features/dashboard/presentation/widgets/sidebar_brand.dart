import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

/// Logo y marca EMI en el sidebar.
class SidebarBrand extends StatefulWidget {
  const SidebarBrand({
    super.key,
    this.isCollapsed = false,
    this.onToggle,
    this.showToggle = true,
  });

  final bool isCollapsed;
  final VoidCallback? onToggle;
  final bool showToggle;

  @override
  State<SidebarBrand> createState() => _SidebarBrandState();
}

class _SidebarBrandState extends State<SidebarBrand> {
  /// Solo true cuando el sidebar ya terminó de expandirse.
  /// Insertar el texto antes de eso causaría reflow durante la animación.
  bool _textVisible = false;

  static const _animDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _textVisible = !widget.isCollapsed;
  }

  @override
  void didUpdateWidget(SidebarBrand old) {
    super.didUpdateWidget(old);
    if (old.isCollapsed == widget.isCollapsed) return;

    if (widget.isCollapsed) {
      // Colapsando: quitar texto inmediatamente
      setState(() => _textVisible = false);
    } else {
      // Expandiendo: esperar a que el AnimatedContainer termine (250ms)
      Future.delayed(_animDuration, () {
        if (mounted) setState(() => _textVisible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          'https://tse1.mm.bing.net/th/id/OIP.rWIa57aBTxT20Yxk3PFouAHaHa?cb=defcache2defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
          width: 30,
          height: 30,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: widget.isCollapsed
          // Colapsado: solo logo centrado y tappable para expandir
          ? Center(
              child: GestureDetector(
                onTap: widget.showToggle ? widget.onToggle : null,
                child: logo,
              ),
            )
          // Expandido: fila con logo + texto (aparece tras animación) + botón ☰
          : Row(
              children: [
                logo,
                if (_textVisible) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EMI',
                          softWrap: false,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.inter(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 22.5 / 18,
                            letterSpacing: 0.45,
                          ),
                        ),
                        Text(
                          'CIENCIAS BÁSICAS',
                          softWrap: false,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.inter(
                            color: AppColors.yellowFFD60A,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 16 / 12,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showToggle)
                    InkWell(
                      onTap: widget.onToggle,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.menu, color: Colors.white, size: 22),
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}
