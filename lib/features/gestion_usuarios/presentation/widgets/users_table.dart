import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Fila de usuario para la tabla.
class UserRowData {
  const UserRowData({
    required this.initials,
    required this.name,
    required this.position,
    required this.email,
    required this.role,
    required this.isAdmin,
    required this.isActive,
  });

  final String initials;
  final String name;
  final String position;
  final String email;
  final String role;
  final bool isAdmin;
  final bool isActive;
}

/// Tabla de usuarios registrados.
class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  static final _sampleData = [
    UserRowData(
      initials: 'JP',
      name: 'Juan Pérez',
      position: 'Administrador del Sistema',
      email: 'juan.perez@emi.edu.bo',
      role: 'ADMINISTRADOR',
      isAdmin: true,
      isActive: true,
    ),
    UserRowData(
      initials: 'AM',
      name: 'Ana Morales',
      position: 'Coordinadora Académica',
      email: 'ana.morales@emi.edu.bo',
      role: 'ADMINISTRADOR',
      isAdmin: true,
      isActive: true,
    ),
    UserRowData(
      initials: 'MG',
      name: 'Maria García',
      position: 'Encargada de Asistencia',
      email: 'maria.garcia@emi.edu.bo',
      role: 'ENCARGADO',
      isAdmin: false,
      isActive: true,
    ),
    UserRowData(
      initials: 'CR',
      name: 'Carlos Rojas',
      position: 'Docente Dedicación Exclusiva',
      email: 'carlos.rojas@emi.edu.bo',
      role: 'ENCARGADO',
      isAdmin: false,
      isActive: false,
    ),
    UserRowData(
      initials: 'LP',
      name: 'Luis Paredes',
      position: 'Encargado de Registro',
      email: 'luis.paredes@emi.edu.bo',
      role: 'ENCARGADO',
      isAdmin: false,
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF2C3E50)),
            columns: const [
              DataColumn(
                label: Text(
                  'NOMBRE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'CORREO INSTITUCIONAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ROL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ESTADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'OPERACIONES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: _sampleData
                .map(
                  (u) => DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: u.isAdmin
                                  ? AppColors.navyMedium
                                  : AppColors.grayLight,
                              child: Text(
                                u.initials,
                                style: TextStyle(
                                  color: u.isAdmin
                                      ? AppColors.white
                                      : AppColors.grayDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  u.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  u.position,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(u.email)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: u.isAdmin
                                ? AppColors.navyMedium
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: u.isAdmin
                                ? null
                                : Border.all(color: Colors.grey.shade400),
                          ),
                          child: Text(
                            u.role,
                            style: TextStyle(
                              color: u.isAdmin
                                  ? AppColors.white
                                  : AppColors.grayDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: u.isActive
                                    ? const Color(0xFF22C55E)
                                    : Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              u.isActive ? 'Activo' : 'Inactivo',
                              style: TextStyle(
                                color: u.isActive
                                    ? const Color(0xFF22C55E)
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          label: Text(
                            'EDITAR',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
