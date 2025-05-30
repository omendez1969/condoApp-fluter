import 'package:flutter/material.dart';

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 0,
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Áreas Disponibles',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAreaItem(
                    context,
                    icon: Icons.pool,
                    title: 'Piscina',
                    subtitle: 'Disponible de 8:00 AM a 8:00 PM',
                  ),
                  const Divider(),
                  _buildAreaItem(
                    context,
                    icon: Icons.sports_basketball,
                    title: 'Cancha Deportiva',
                    subtitle: 'Disponible de 6:00 AM a 10:00 PM',
                  ),
                  const Divider(),
                  _buildAreaItem(
                    context,
                    icon: Icons.local_fire_department,
                    title: 'Área de BBQ',
                    subtitle: 'Disponible de 10:00 AM a 10:00 PM',
                  ),
                  const Divider(),
                  _buildAreaItem(
                    context,
                    icon: Icons.celebration,
                    title: 'Salón de Eventos',
                    subtitle: 'Disponible de 9:00 AM a 11:00 PM',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              // TODO: Implementar la lógica para crear una nueva reserva
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.info, color: colorScheme.onPrimary),
                      const SizedBox(width: 8),
                      const Text('Función disponible próximamente'),
                    ],
                  ),
                  backgroundColor: colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Nueva Reserva'),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        child: Icon(icon, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios, size: 16),
        onPressed: () {
          // TODO: Implementar la navegación al detalle del área
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.info, color: colorScheme.onPrimary),
                  const SizedBox(width: 8),
                  const Text('Detalles disponibles próximamente'),
                ],
              ),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
