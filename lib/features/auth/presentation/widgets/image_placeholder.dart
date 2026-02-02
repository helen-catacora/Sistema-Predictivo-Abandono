import 'package:flutter/material.dart';

/// Contenedor rojo como placeholder para imágenes en desarrollo.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.size = 48,
    this.borderRadius = 8,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
