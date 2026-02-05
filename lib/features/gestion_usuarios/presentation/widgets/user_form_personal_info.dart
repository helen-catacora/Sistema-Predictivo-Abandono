import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Sección Información Personal.
class UserFormPersonalInfo extends StatelessWidget {
  const UserFormPersonalInfo({
    super.key,
    required this.nombresController,
    required this.apellidosController,
    required this.cedulaController,
    required this.telefonoController,
    required this.cargoController,
  });

  final TextEditingController nombresController;
  final TextEditingController apellidosController;
  final TextEditingController cedulaController;
  final TextEditingController telefonoController;
  final TextEditingController cargoController;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      icon: Icons.person_outline,
      title: 'Información Personal',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nombresController,
                  decoration: const InputDecoration(
                    labelText: 'Nombres *',
                    hintText: 'Ej: Juan Carlos',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos *',
                    hintText: 'Ej: Pérez Gonzales',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: cedulaController,
                  decoration: const InputDecoration(
                    labelText: 'Cédula de Identidad *',
                    hintText: 'Ej: 1234567 LP',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono de Contacto',
                    hintText: 'Ej: 77123456',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: cargoController,
            decoration: const InputDecoration(
              labelText: 'Cargo o Función *',
              hintText:
                  'Ej: Docente Tiempo Completo, Secretaria Académica',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
        ],
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  const FormSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.navyMedium,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}
