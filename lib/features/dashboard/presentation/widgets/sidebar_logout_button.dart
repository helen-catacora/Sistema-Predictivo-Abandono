import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sistemapredictivoabandono/features/auth/presentation/providers/me_provider.dart';

/// Botón "Cerrar Sesión" en la parte inferior del sidebar.
class SidebarLogoutButton extends StatelessWidget {
  const SidebarLogoutButton({
    super.key,
    required this.onPressedLogout,
    required this.onPressedProfile,
  });

  final Function() onPressedLogout;
  final Function() onPressedProfile;

  @override
  Widget build(BuildContext context) {
    final profile = context.read<MeProvider>().me;
    return GestureDetector(
      onTap: onPressedProfile,
      child: Container(
        decoration: BoxDecoration(color: Color(0xff002855)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Center(
                  child: Text(
                    profile?.nombre.substring(0, 1) ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile?.nombre ?? 'Cnl. Admin EMI',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 20 / 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Sesión Activa',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Color(0xff9CA3AF),
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: onPressedLogout,
                child: Icon(Icons.logout, color: Color(0xff9CA3AF), size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
