import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui;

import '../../../../core/constants/app_colors.dart';

/// Diálogo para validar la identidad con reCAPTCHA v2 tras un login exitoso.
class RecaptchaDialog extends StatefulWidget {
  const RecaptchaDialog({super.key});

  @override
  State<RecaptchaDialog> createState() => _RecaptchaDialogState();
}

class _RecaptchaDialogState extends State<RecaptchaDialog> {
  static int _viewIdCounter = 0;
  late final String _viewId;
  StreamSubscription<web.MessageEvent>? _messageSubscription;

  _RecaptchaDialogState() {
    _viewId = 'recaptcha_dialog_${_viewIdCounter++}';
  }

  @override
  void initState() {
    super.initState();

    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe =
          web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.style.height = '100%';
      iframe.style.width = '100%';
      iframe.src = '/html/recaptcha.html';
      iframe.style.border = 'none';
      return iframe;
    });

    _messageSubscription = web.EventStreamProviders.messageEvent
        .forTarget(web.window)
        .listen((web.MessageEvent e) {
          try {
            final jsData = e.data;
            if (jsData == null) return;
            final dartData = jsData.dartify();
            if (dartData is! Map) return;

            final typeStr = dartData['type'];
            if (typeStr == null) return;

            if (typeStr == 'recaptcha_success') {
              if (mounted) Navigator.of(context).pop(true);
              return;
            }
            if (mounted) setState(() {});
          } catch (err) {
            // Ignorar errores de parsing o datos inesperados
          }
        });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _cancel() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.navyMedium,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verificación de identidad',
                        style: GoogleFonts.inter(
                          color: AppColors.navyDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Complete el reCAPTCHA para continuar al sistema',
                        style: GoogleFonts.inter(
                          color: AppColors.grayDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: HtmlElementView(viewType: _viewId),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                TextButton(
                  onPressed: _cancel,
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      color: AppColors.grayDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
